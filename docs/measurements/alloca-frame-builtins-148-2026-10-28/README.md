# `__builtin_alloca` and level 0's frame builtins, Buster #148

Compiler branch: `claude/happy-dhawan-eafb58` of buster14a/buster, for
[this claim on #148](https://github.com/buster14a/buster/issues/148#issuecomment-6478890775).

The branch lowers `__builtin_alloca` to Tier 0's `ALLOCA`, and level 0's
`__builtin_frame_address` and `__builtin_return_address` through a new Tier 0
kind, `FRAME_ADDRESS`. Neither appears in SQLite: this record checks that the
default path, `-c` of the frozen `sqlite3.c`, writes the same object and costs
the same. It also keeps the corpus survey behind the claim.

## Sources and host

Each tree is a `git archive` of its commit, extracted into a fresh directory on
the 9700X:

- **base:** `ba379033f706652a32fcc3a64b63c5b031f34428`, main, the branch's
  merge-base;
- **head:** `c2dc7646e51cc81acbd25468be9f9f2913c2ed4f`, the first commit, with
  `FRAME_ADDRESS` numbered 46;
- **head2:** `16a72e356176851241ece309d1318d9c83ab7b50`, the final head, with `FRAME_ADDRESS`
  numbered 45 and `JUMP_INDIRECT` 46.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9. Every
run is pinned to CPU 2, whose governor is `performance`. Each build and each
measurement ran in a hold of its own on the host's lock (`exclusive.sh`). The
lock's waiting messages are left out of the logs: they name other jobs. Only the
lines the scripts and the compiler print are kept.

Builds: `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds
(`scripts/build-tree.sh`, `builds/`). The executables' SHA-256:

- base: `ac01998ef81588ffc023a62d2d6789a67cddcdd4a0257629ebd2959daed20f8a`;
- head: `edd5c55244b049a21ab3b9d885f5883298d1ee2f068a98f659fe0a0e0ce814a1`;
- head2: `7375d963c8277c88a31c9616d1b81735c2e95304650d7815123c1e5985790423`.

## Method

The command is the 9700X job's compile-time step's `-c` of the frozen SQLite
3.53.2 amalgamation:
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`,
SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`,
with `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`. Pinned to one
CPU, the driver compiles on one lane.

One hold per run (`scripts/measure.sh`, started by `scripts/queue.sh` and
`scripts/queue2.sh`):

1. A drive check: each tree compiles once. Both exit 0 and write byte-identical
   objects (`cmp`).
2. Eight rounds of `perf stat -r 3 -e instructions:u,cycles:u,task-clock` per
   tree, the order alternated by round.
3. `benchmark-backend-source`, with the 9700X job's options, on the same file:
   two rounds, the order swapped.

Run 1 compared base with head, run 2 base with head2. Run 1 used the same
script before its tree names became arguments, with `base` and `head` fixed.
`scripts/analyze.py` gives the medians and the per-round ratios.

## Results

`-c` of `sqlite3.c`, medians of the rounds' means. The ratios are per round,
and their median:

| Run | Instructions, base | Instructions, head | Difference | Cycles, median of per-round ratios | Task clock, same |
|---|---:|---:|---:|---:|---:|
| 1 (head) | 1,226,128,600 | 1,226,103,317 | -25,283 (-0.002%) | -0.62% (-1.08% to +0.02%, and +9.37%) | -0.37% |
| 2 (head2) | 1,226,128,678 | 1,226,127,830 | -848 (-0.0001%) | -0.03% (-0.46% to +0.36%) | -0.06% |

Each tree's instructions vary by at most 18 within a run. Run 1's +9.37% is
round 7's head sample, whose three runs varied by 4.6% (a disturbance). The
other seven of its rounds favour head by up to 1.08%, inside the 0.7% placement
swings that two builds of the same work show on this file (#536's record). Run
2's cycles straddle zero.

Tier 0 on the same file's 2,602 functions (396,872 typed entries,
`benchmark-backend-source`): instructions per typed entry, with each round's
nanoseconds per entry:

| Variant | base (4 samples) | head (46) | head2 (45) |
|---|---|---|---|
| `vector` (`tier0_compile`) | 152.43; 11.72 to 11.76 | 152.37; 11.74, 11.75 | 152.43; 11.68, 11.70 |
| `scalar` (`tier0_compile_scalar`) | 531.72; 31.85 to 32.01 | 532.81; 31.61, 31.66 | 531.76; 32.10, 32.14 |
| `validate` | 30.03; 2.31 to 2.33 | 30.03; 2.32, 2.33 | 30.03; 2.31, 2.31 |
| `validate-scalar` | 129.52; 8.24 to 8.27 | 129.52; 8.31, 8.34 | 129.52; 8.33, 8.35 |

`-c` runs the vector paths on this host. With `FRAME_ADDRESS` at 46,
`tier0_moves_stack` needed a second compare, and the scalar compile ran 1.09
more instructions per entry. Numbering it 45, after `STACK_RESTORE`, keeps the
stack's four kinds one range: +0.04.

## Corpus survey

`survey/` holds the survey of the claim, run on the laptop (Ryzen 9 7940HS,
clang 23.1.4) with main `ba379033`'s build and head `c2dc7646`'s build:

- **`survey.sh`:** each unit by `-c` and by `clang -c`.
- **`fetch.sh`:** the upstream files it used, fetched on 2026-10-28. These are
  stb, dr_libs, minimp3 and nuklear at master; QuickJS 2024-01-13; xxHash
  v0.8.2; lz4 v1.10.0; yyjson 0.10.0; miniz 3.0.2; and duktape 2.7.0.
- **`units/`:** the one-line units that define the header libraries'
  implementation macros.

`results-main.txt` and `results-head.txt` give each unit's first error. Clang
compiles all 24 units. On main 9 fail, and on head 7. stb_vorbis.c and QuickJS's
libregexp.c, which stopped at `alloca`, compile.

## Limits

- One host and one lane, one build of each tree.
- The cycles' differences are within the placement noise; the instruction
  counts are the precise comparison.
- The survey's master branches are as fetched that day, without a pinned
  revision.
