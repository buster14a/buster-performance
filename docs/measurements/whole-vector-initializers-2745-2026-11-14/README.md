# No clear before a vector's whole value: the compiler's own lexer (buster#2745)

14 and 15 November 2026. [buster14a/buster#2745](https://github.com/buster14a/buster/issues/2745) asks that a struct
or union initialized by one vector of its whole size not be zeroed first, and that `c_tokenize`'s count be recorded
against [#2742](https://github.com/buster14a/buster/pull/2742)'s. The change is
[buster14a/buster#2789](https://github.com/buster14a/buster/pull/2789), head `5d57bda543f3e076c652ed223f09e78445bb9884`,
against main `1935a91fbd07b6fec0f6d651c9649bb7f9ef4d3a` (its base).

## Result

**9700X** (`9700x/`), Release compilers, each lexer program `measure-tier1-rows --base`'s build (`-march=native`),
`c_tokenize`'s `benchmark-lexer` medians of 21 passes, three runs each, pinned to CPU 2, one lock hold a run. The file
is #2742's record's 46,679-byte one (it needs no scalar lexer); `src` is the head's source tree (1,065 files, 57.8 MB).

| Build | file: cycles/B | file: instructions/B | `src`: cycles/B | `src`: instructions/B |
| --- | ---: | ---: | ---: | ---: |
| Tier 0 (the head's compiler) | 49.61, 49.71, 49.76 | 69.647 | 49.93, 49.66, 49.72 | 70.416 |
| `--tier1`, main `1935a91f` | 8.079, 8.075, 8.079 | 12.445 | 8.477, 8.470, 8.504 | 12.904 |
| `--tier1`, head `5d57bda5` | 7.899, 7.904, 7.904 | 11.920 | 8.295, 8.296, 8.297 | 12.389 |
| clang -O2 | 0.654, 0.657, 0.653 | 2.954 | 0.845, 0.845, 0.845 | 3.006 |

The head's `--tier1` `c_tokenize` takes 2.2% fewer cycles than main's on the file and 2.1% fewer on `src` (8.079 to
7.904 and 8.477 to 8.296 cycles per byte, medians of the three), with 4.2% and 4.0% fewer instructions. #2742's record
had 8.33 and 8.69 cycles per byte at its head `6c28f8a7`; main has moved since. `c_tokenize_scalar`, which this doesn't
touch, is 44.770 instructions per byte by both Tier 1 builds (11.95 to 11.97 cycles per byte on `src`).

`measure-tier1-rows`' own table (`9700x/rows.log`, one run of each, on the file): the lexer unit's records 76,411 to
73,674; the lexer program 19.95 to 19.78 M user cycles and 86.70 to 86.08 M instructions; the machine rows' and the scan's
units unchanged within 0.8%.

**Every instruction counted** (`results/`), as [buster-performance#530](https://github.com/buster14a/buster-performance/pull/530)
counted them: `c_tokenize` on its 9,076-byte `mid200.c`, one call, single-stepped in the session's virtual machine (an
Intel Xeon with AVX-512, `host.txt`; Develop compilers of the same two commits). Totals include the 2,698 instructions
outside the executable that every build runs:

| Build | instructions | per byte | immediate stores to the stack |
| --- | ---: | ---: | ---: |
| clang -O2 | 27,785 | 3.06 | |
| `--tier1`, #2742's head `6c28f8a7` (#530's record) | 122,190 | 13.46 | 23,489 |
| `--tier1`, main `1935a91f` | 114,872 | 12.66 | 28,458 |
| `--tier1`, head `5d57bda5` | 110,084 | 12.13 | 23,850 |

The head removes 576 runs of eight zeroing quadword stores (4,608 stores, 4,788 instructions in all: 4.2% of main's,
the 9700X's instruction ratio), 32.5 runs per 512-byte block (`results/mid200-base.runs.txt` against
`results/mid200-tier1.runs.txt`): those followed by the vector's load (234 runs), its store (144), a load from memory
(90), a vector operation (54) and a general-register load (54).

## What is left

396 runs of eight zeroing stores are still there, each followed by one quadword store of a register at the object's
first byte and then the 64-byte load of the object: the lexer's `BUSTER_LEX_LANES(x)`, which is `(U64x8){ x }`, a vector
literal whose first lane is a scalar and whose other lanes are zeros. The zeros are required there; a vector built from
scalars without memory (`vmovq` zero-extends) is #2744's build-vector item, not #2745's. Both builds also have 18 runs
of eight followed by a general-register load from the stack.

## The issue's three functions

`issue.c`, by the compilers of this session (`-march=native`, instructions without the alignment padding): each of
`lit`, `decl` and `uni` is the same.

| Tier | main `1935a91f` | head `5d57bda5` |
| --- | ---: | ---: |
| `--tier1` | 35 instructions, 8 zeroing stores | 27, none |
| Tier 0 | 46 instructions, 8 zeroing stores (`lea`, `add`, `mov` each) | 23, none |

`fixtures.c` is the session's semantic check of the edge cases, which the pull request's tests carry: the same output
by clang -O0, Tier 0 and `--tier1` (strict) at `-march=x86-64` and `native`, on a dirtied stack, with the clears that
stay (a volatile object, a wider object, a narrower union member, and a union whose designator moves to another member
after the vector's, whose rest clang leaves zeros).

## Method

```sh
# 9700X: 9700x/run.sh, started detached by systemd-run --user; every build and run its own exclusive.sh hold, with
# timeout inside the hold and the busiest processes before and after it (9700x/procs/).
# The session's virtual machine: Develop builds of both commits (BUSTER_TOOLCHAIN=path ./build.sh), then
./build/compiler measure-tier1-rows --clang "$(command -v clang)" --base COMPILER-1935a91f --lexer mid200.c \
    --rounds 2 --passes 1 --runs 1 --warmups 0 --directory DIR --keep --uncounted
taskset -c 1 ./stephist --entry $(nm DIR/lexer-tier1 | grep ' t c_tokenize$' | cut -d' ' -f1) --calls 1 \
    --output mid200-tier1.hist -- DIR/lexer-tier1 mid200.c
python3 -I annotate.py DIR/lexer-tier1 mid200-tier1.hist > mid200-tier1.summary.txt
python3 -I annotate.py DIR/lexer-tier1 mid200-tier1.hist dump > mid200-tier1.dump
python3 -I runs.py mid200-tier1.dump > mid200-tier1.runs.txt
```

`stephist.c`, `annotate.py` and `runs.py` are #1344's record's, unchanged:
[tier1-vector-lexer-breakdown-1344-2026-11-14 at 9d0ff214](https://github.com/buster14a/buster-performance/tree/9d0ff21455d93f8be6f1ed52789f1011ae5e5e28/docs/measurements/tier1-vector-lexer-breakdown-1344-2026-11-14).
`base` in the file names is main `1935a91f`, `tier1` the head, `clang2` clang -O2.

## Files

- `9700x/`: `run.sh`, `run.log` (each run's line), `rows.log` (the harness), each run's log
  (`lexer-BUILD-INPUT-N.log`), `procs/` (each hold's busiest processes and load, before and after), the programs' and
  compilers' hashes, `host.txt` (kernel, CPU, the system clang the harness links with, CPU 2's governor).
- `results/`: the histograms (`*.hist`), summaries by function and class, the immediate-store runs by shape, the
  dumps of every executed instruction (`*.dump.gz`), the programs' and compilers' hashes, `rows-local.log`.
- `mid200.c`, `issue.c`, `fixtures.c`: the inputs.

## Limits

- The lock was busy all night: 3 to 25 minutes passed between successive runs, nearly all of it waiting, and the
  load average was 4 to 8 when a hold began (`procs/*.before`). Three short `sha256sum` processes of user david, not
  this script's (its own hash had finished 13 minutes before), had just started when snapshots were taken: before
  `lexer-tier0-mid-1` (CPU 2; `exclusive.sh` listed it too, `lexer-tier0-mid-1.log`), and after `lexer-base-mid-1`
  (CPU 2) and `lexer-base-mid-2` (CPU 0). No other process was busy. The three runs of each build agree within 0.6%
  (`--tier1`'s within 0.4%).
- Tier 0's lexer is built by the head's compiler only (`measure-tier1-rows` builds Tier 0 once), so this record has no
  Tier 0 comparison on the 9700X; the issue's functions show Tier 0's side.
- The single-stepped counts are an Intel host's, where `-march=native` is not `znver5`; the 9700X's instruction ratio
  (0.958 on the file) agrees with theirs (0.958).
