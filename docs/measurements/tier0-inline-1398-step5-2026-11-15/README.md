# #1398 step 5: Tier 0's splice of several returns and results in memory, on the 9700X

[buster#1398](https://github.com/buster14a/buster/issues/1398)'s plan step 5: Tier 0's splice of `always_inline`
callees with several returns (each `RETURN` a jump to the copy's end) and with a result through a hidden pointer
(parameter 0 bound to the call's result object). Base is step 3's head, buster `b791311d` (PR #2793); head is step 5's
first commit `d84de3bf`, which spliced both shapes by default. Both were built with `./build.sh --config Release` at
`BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`, on the Ryzen 7 9700X (`environment.txt`), and every timed run had its
own `exclusive.sh` hold on CPU 2. Lock-wait notices, which quoted other sessions' commands, are stripped from the logs.

**Outcome:** the shapes don't pay at Tier 0, so the PR makes them opt-in (`--tier0-inline-shapes`) and leaves the
default as step 3's. Splicing results in memory costs the self-built lexer 1.7% more instructions per byte. Spliced
into a large caller, the callees' loop locals lose the callee-saved registers they hold as functions of their own,
because Tier 0's homes go to the locals with the most references in the whole function. Splicing several returns
changes no instruction count there. Both shapes grow `main.c`'s `.text` 2.4 times, with nine copies of the lexer's
`tokenize_chunks`.

## Scripts

- `run-1398s5.sh BASE HEAD`: builds both trees, then runs:
  - `main.c`'s `-c` object (complete driver) by each tree and by clang -O0;
  - `-c` of `main.c` and of the frozen `sqlite3.c` by `time-runs` under 3 `ab` rounds (base, head, base-again);
  - the head's sources self-built at Tier 0 by each compiler (`tools/ci/selfhost.c`'s bootstrap, without `-g`), and
    `benchmark-lexer`, `benchmark-refinement` and `benchmark-files` twice each by both, once by clang's Release build.
- `perf-s5.sh`: `perf record -e instructions:u -c 1000003` of both self-built compilers' `benchmark-lexer src`,
  reported by symbol (`raw/perf`).
- `split-s5.sh` with `experiment-split.patch`: a throwaway compiler (step 5 plus `BUSTER_S5_EXPERIMENT`, never part of
  a PR) whose `r` splices several returns only and whose `m` splices results in memory only. Each one's lexer unit
  (`c_lexer_benchmark.c`) is linked with base's other self-built units, and so is head's (`lexhead`) (`raw/split`).
- `lines-s5.sh`: the `r` and `m` lexer units with `-gline-tables-only`, profiled by source line (`raw/lines`).

## Results

**The self-built lexer** (`raw/selfhost`), Tier 0 builds of the same sources, in ms:

| benchmark | base (step 3) | head (step 5) | clang Release |
| --- | ---: | ---: | ---: |
| `c_tokenize` | 548.0, 548.0 | 559.0, 559.1 | 8.9 |
| `c_tokenize` instructions/B | 78.583 | 79.949 | 3.006 |
| `c_tokenize_scalar` (the control) | 279.4, 279.5 | 282.9, 284.2 | 84.8 |
| `refine_tokens_fused` | 570.0, 569.8 | 570.0, 569.5 | 12.8 |
| `benchmark-files` `main.c`, 1 lane | 1,094.0, 1,095.1 | 1,105.1, 1,107.5 | 33.2 |
| the 43 units' compile (s) | 17.70 | 18.09 | |

**Which shape** (`raw/split`), `c_tokenize` instructions per byte. They are exact, run to run; the split's times moved
by up to 19% between its two rounds, so they aren't compared:

| lexer unit, the other units base's | instructions/B |
| --- | ---: |
| base | 78.583 |
| `r`: several returns only (`tokenize_chunks` into its nine variants) | 78.583 |
| `m`: results in memory only (`scan_lines`, `write_chunk` into `tokenize_chunks`) | 79.949 |
| `lexhead`: head's lexer unit | 79.949 |
| head | 79.949 |

**Where** (`raw/perf`): base's `tokenize_chunks`, `write_chunk` and `scan_lines` take 114,060 samples of a million
instructions. Head's `tokenize_c`, where all three are spliced, takes 115,714, about 1.5% more. The scalar lexer's
samples only move from `peek_char` to `skip_line_comment` (with the same sum, 83,430 and 83,396), whose `peek_char`
calls head splices.

**Why** (`raw/analysis/write-chunk-function-vs-spliced.txt`): base's `write_chunk` function and its copy spliced into
`tokenize_chunks` in `m`, aligned by their first `vpcompressb`. As a function, `write_chunk` keeps its output cursors and
start offset in `r12`, `r14` and `r15` (111 of its 1,707 instructions name `rbx` or `r12` to `r15`). Spliced, they are
frame slots, so `mov %r12d,(%rcx)` becomes `mov N(%rsp),%edx; mov %edx,(%rcx)`. `tokenize_chunks` has 32,148
instructions, and Tier 0 gives its free registers to the locals with the most references in the whole function
(`tier0_assign_homes`, `docs/tier0.md` "Homes"). The loop runs 8 times a chunk, but its locals' references are few
next to the caller's straight-line ones. With 512-byte chunks, the 1.37 instructions per byte are about 700 a chunk.

**Under `-gline-tables-only` it reverses** (`raw/lines`): `r` 84.922 and `m` 81.819 instructions per byte, both above
the builds without `-g` (78.583). Line tables change Tier 0's code here, and those builds can't explain the default's
difference. Their line profile also charges each spliced body to its call's line.

**`main.c`'s object** (`raw/objects/sizes.txt`, complete driver, `-c --lanes 1`):

| | bytes | local functions | `.text` |
| --- | ---: | ---: | ---: |
| base | 9,599,952 | 1,249 | 1,688,510 |
| head | 11,971,424 | 1,246 | 4,045,182 |
| clang -O0 | 8,446,240 | 1,238 | 1,601,599 |

Head leaves out `tokenize_chunks`, `scan_lines` and `write_chunk`, as clang -O0 does. Each of the nine variants carries
a 290 KB copy of `tokenize_chunks` with its callees.

**The compile** (`raw/compile`), user cycles, head and base-again against base, by round:

| unit | head | base-again | instructions |
| --- | --- | --- | --- |
| `sqlite3.c` (590 M cycles) | −0.25% (over copies −0.50% to +0.07%) | −0.02% | +0.01% (+0.18 M) |
| `main.c`, complete driver (7.97 G cycles) | +0.67%, +0.59%, +0.82% | +0.11%, −0.12%, +0.17% | +1.10% (+235 M) |
