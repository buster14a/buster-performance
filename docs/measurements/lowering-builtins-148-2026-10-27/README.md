# Long double, `__int128` and `_BitInt` builtins in the C driver's lowering: the 9700X A/B for #148

2026-10-26 and 27. Paired measurements of the default paths for two branches of
[buster14a/buster#148](https://github.com/buster14a/buster/issues/148), the slice that makes the C driver's
lowering take the builtins 15 functions of this compiler's own `main.c` call:

- `claude/long-double-builtins-148-b51b04`: long double's classification builtins and `fabsl`, and the
  overflow builtins' `__int128` operands and destinations;
- `claude/bit-int-lowering-148`, stacked on it: `_BitInt(N)` values of up to 64 bits.

Neither changes what `-c sqlite3.c` compiles (its object is main's, byte for byte, for every tree here), so
these runs measure what the branches cost code that doesn't use them. Two of the branches' first versions cost
it something, which the final heads don't: see "What the first versions cost".

## Revisions and trees

Each tree up to `bitint2` was copied on the 9700X from the one before it and patched, then built there. `manifests/` has the
sha256 of every file of `build.sh`, `src` and `tests` of each measured tree (`tree-*.sha256`) and of each
commit (`commit-*.sha256`).

| Tree | Sources | `build/compiler` sha256 |
| --- | --- | --- |
| `main` | `e04462c12f1ce25c70e41e8aa4acf48f4d7c4004`'s tree exactly (main, the branches' base) | `5da852db1ceb891a475a257abe94bd520f20c416b0d7f7f62b453b24130664a6` |
| `main2` | `main`'s executable, copied: an A/A control | the same |
| `head` | the first branch's first version, `8ec46379a3a08fa39c93560394723a0a1f2c81d4`, exactly | `ed324a02748bd99b6a020b1236bf861ad1c8e5df82f89d896fd49e5d8510fcaa` |
| `headb` | `head` with `patches/strict.patch`: the first branch's head as its pull request opened, `da1f3894`, but for one comment of `c_builtin_lower.c` rewrapped after the measurement (no code) | `6c057ea510c56e8b7f84ee2f740bab3609e3e08b9f5d4c417f6e09cd7f84998c` |
| `bitint` | `headb` with `patches/bitint.patch`: the second branch's first version | `1da59a414caa5b443eab008318c516b02967cc651197c79e306805d6feb796f2` |
| `bitint2` | `headb` with `patches/bitint2.patch`: the second branch's head as its pull request opened, `2eb6e6f9`, exactly (with `patch`'s `c_check_program_lower.c.orig` beside it, which nothing compiles) | `e4ff213e59371c30aed7f6f3ef42966cd80a4acc87e9ad1107f4902eb9953453` |
| `headc` | `1338d2643f270f601039ad77d3a15919fee4599d`'s tree exactly, a `git archive`: the first branch after review | `409f1d852060105f905ed6530237002b53cbce756bff848ff4eafd8187f6d7b0` |
| `bitint3` | `02cc348d73291bd1c6edbb9a832903b7e31ef023`'s tree exactly, a `git archive`: the second branch after review | `ddb609eb08e4ca237e7cd8dfec782886f16aa9694b58c05c6845c9fded0ee19e` |

The heads the pull requests opened with: `da1f38940c37fa6f05ea0b46ee1d391f07d991bd` and
`2eb6e6f93f60863f7de9b140cac0c6cbb969c6c4`; after review: `1338d2643f270f601039ad77d3a15919fee4599d` (`headc`) and
`02cc348d73291bd1c6edbb9a832903b7e31ef023` (`bitint3`), measured in `logs/rounds4`.

## Host, builds and inputs

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, transparent huge pages `always`, btrfs. clang 23.1.1 built each tree
with `BUSTER_DEBUG_INFO=0 ./build.sh`, under its own hold of the shared lock. Inputs: `sqlite3.c` (sha256
`b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`) and c-testsuite's 220 single-exec
programs at `5c7275656d751de0e68b2d340a95b5681858ed07`.

## Commands

`scripts/rounds.sh` (the first set) and `scripts/rounds2.sh` (the second and third, with the trees as its
arguments) run each round under one hold of the shared lock, the trees in an order that rotates by round, every
process pinned to CPU 2. Each tree runs:

- `time-runs --runs 11 --list -c -o OUT sqlite3.c`: the driver's whole `-c`, its median wall time and peak
  resident set of 11 processes (`*-driver.log`);
- `benchmark-lowering-source sqlite3.c` and `benchmark-lowering-source` of c-testsuite's 220 programs: the
  lowering of every referenced definition (`referenced_ns`) and of every definition (`all_ns`), 21 passes
  after checking (`*-lowering-*.log`);
- `benchmark-builtin-lowering`: the builtin recipes' synthetic expansion through Tier 0 and encoding, scalar
  and vector publication (`*-builtin-lowering.log`).

After its rounds each set ran `perf stat -r 11 -e instructions:u,cycles:u` of `-c sqlite3.c` on each tree, the
trees interleaved twice (`perfstat.log`). `scripts/summarize.py DIR TREES...` gives each figure's median over
the rounds (`summary.txt`).

- `logs/rounds1`: `main`, `head`, `main2`, 6 rounds.
- `logs/rounds2`: `main`, `headb`, `bitint`, `head`, `main2`, 2 rounds, stopped once `bitint`'s cost showed.
- `logs/rounds3`: `main`, `headb`, `bitint2`, `main2`, 6 rounds: the heads the pull requests opened with.
- `logs/rounds4`: `main`, `headc`, `bitint3`, `main2`, 6 rounds: the heads after review.

`scripts/perfrecord.sh` and `scripts/perfrecord2.sh` recorded user cycles of `benchmark-lowering-source
sqlite3.c` (frequency mode, CPU 2), with `perf stat` of instructions, cycles and branch misses for the second;
`profiles/*.symbols` are the per-symbol shares.

The progress logs and `perfstat.log` keep only the scripts' own lines: the shared lock's waiting messages,
which name other sessions' commands and links, are removed.

## Results: the heads the pull requests opened with (`logs/rounds3`)

Medians of the 6 rounds' medians; the change from `main`.

| | `main` | `headb` (first branch) | `bitint2` (second branch) | `main2` (A/A) |
| --- | ---: | ---: | ---: | ---: |
| `-c sqlite3.c`, wall | 191.16 ms | 190.68 ms (−0.25%) | 191.68 ms (+0.27%) | 190.83 ms (−0.17%) |
| `-c sqlite3.c`, peak resident set | 709.8 MB | 711.4 MB (+0.23%) | 710.7 MB (+0.13%) | 709.3 MB (−0.07%) |
| lowering `sqlite3.c`, referenced | 37.55 ms | 37.34 ms (−0.57%) | 37.66 ms (+0.30%) | 37.11 ms (−1.18%) |
| lowering c-testsuite, referenced | 1.991 ms | 1.987 ms (−0.21%) | 1.988 ms (−0.13%) | 1.987 ms (−0.20%) |

`perf stat` of `-c sqlite3.c` (two blocks of 11 runs per tree):

| | `main` | `headb` | `bitint2` | `main2` |
| --- | ---: | ---: | ---: | ---: |
| user instructions | 2,290,952,023 | 2,291,195,691 (+0.011%) | 2,290,578,153 (−0.016%) | 2,290,952,119 |
| user cycles | 891.7 M, 895.9 M | 891.4 M, 891.4 M | 896.7 M, 897.3 M | 891.2 M, 893.8 M |

The peak resident set moves in steps of about 1 MB between rounds for one executable (`main2`: 708.8 MB in
rounds 0 to 2, 709.8 MB in 3 to 5; `headb`: 710.9 MB, then 711.9 MB), which a branch's layout moves too (the
branches' `.bss` starts 77,952 and 115,200 bytes later than main's, with THP `always`); neither branch adds an
allocation on this path. `benchmark-builtin-lowering`'s vector cases ran 10 to 13% slower in `main` than in `main2`, the same
executable copied, in every round: that benchmark doesn't tell builds apart at this scale (the branches' vector
figures fall below both main copies', and their scalar figures within 3.3% of them; `summary.txt`).

## The heads after review (`logs/rounds4`)

The review of both pull requests changed each head once: the first branch's `1338d2643f270f601039ad77d3a15919fee4599d`
refuses malformed 128-bit descriptors (`cbuiltin_lower_wide`, only builtin recipes run it), and the second's
`02cc348d73291bd1c6edbb9a832903b7e31ef023` extends an update's old `_BitInt` value from its width (one more flag test
per update in programs without `_BitInt`). `rounds2.sh 6 rounds4 main headc bitint3 main2` measured them as the
third set measured the earlier heads. The trees were `git archive`s of the two commits, exactly
(`manifests/tree-headc.sha256`, `tree-bitint3.sha256` against `commit-1338d264.sha256`, `commit-02cc348d.sha256`);
`build/compiler` sha256 `409f1d852060105f905ed6530237002b53cbce756bff848ff4eafd8187f6d7b0` (`headc`) and
`ddb609eb08e4ca237e7cd8dfec782886f16aa9694b58c05c6845c9fded0ee19e` (`bitint3`). Every tree's object of
`sqlite3.c` was main's.

| | `main` | `headc` (first branch) | `bitint3` (second branch) | `main2` (A/A) |
| --- | ---: | ---: | ---: | ---: |
| `-c sqlite3.c`, wall | 190.95 ms | 190.64 ms (−0.16%) | 191.30 ms (+0.19%) | 190.74 ms (−0.11%) |
| `-c sqlite3.c`, peak resident set | 709.8 MB | 711.0 MB (+0.17%) | 710.8 MB (+0.13%) | 708.8 MB (−0.14%) |
| lowering `sqlite3.c`, referenced | 37.38 ms | 37.74 ms (+0.95%) | 37.46 ms (+0.22%) | 37.14 ms (−0.64%) |
| lowering c-testsuite, referenced | 1.989 ms | 1.997 ms (+0.39%) | 1.979 ms (−0.49%) | 1.989 ms (−0.00%) |
| user instructions (`perf stat -r 11`) | 2,290,952,040 | 2,291,203,756 (+0.011%) | 2,290,584,514 (−0.016%) | 2,290,952,065 |
| user cycles (two blocks of 11) | 894.6 M, 894.7 M | 891.9 M, 890.6 M | 897.0 M, 895.8 M | 896.0 M, 892.3 M |

`headc`'s lowering median is 0.95% above main's (above it in 5 of 6 rounds, by up to 0.6 ms) while its `-c` is
0.16% faster and its cycles 0.3% fewer; `headb`, whose lowering code is `headc`'s, measured 0.57% below main in the
third set. The descriptor check that differs runs only in builtin recipes, so the 1.5% between the two heads'
medians is how far the builds' layouts move the lowering benchmark.

## What the first versions cost

- `head`, the first branch's first version (`logs/rounds1`): lowering `sqlite3.c` +1.96% and `-c` +0.37%
  against `main`, with +0.005% instructions. Its strict classifications (FENV_ACCESS's `fpclassify` and
  `isinf_sign`), inlined into the tasks' loop, made `check_lower_drain` 578 bytes larger, and
  `check_lower_operand`, unchanged, moved off its 64-byte line: in the profile (`profiles/pr1-*.symbols`) the two
  took 0.8 and 0.4 points more of the cycles, `main2` neither. `headb` moves the strict classifications out of
  line (`check_lower_floating_strict`), as few tasks are; its loop is 2,959 bytes smaller than main's.
- `bitint`, the second branch's first version (`logs/rounds2`): lowering `sqlite3.c` +5.08% and `-c` +0.85%
  against `main`; in the lowering benchmark, 0.85% fewer instructions than `headb` and 5% more cycles
  (`profiles/pr2-*.stat`). Its out-of-line `_BitInt` handler took the expression's task (32 bytes) by value,
  so clang copied every task whole to the stack as its expansion began, with a 32-byte load that the push's
  narrower stores can't forward: 54% of `check_lower_drain`'s samples fall on the store after that load
  (`profiles/pr2-bitint-drain-hottest.txt`, `profiles/pr2-bitint-drain-copy.txt`). `bitint2` passes the task's
  fields instead; its loop has the one 32-byte load main's has (the complex values' task), and its profile
  against `headb` (`profiles/pr2b-*`) has the same cycles (9.875 G against 9.884 G).

## Limitations

These runs time code that doesn't use the branches' features; the features' own costs are the builtin recipes'
expansions, which only `benchmark-builtin-lowering` times, and which no program here calls. Layout effects of
about 1% between builds of one tree are within reach of these numbers: the A/A control (`main2`) differs from
`main` by up to 1.2% in the lowering benchmark's medians.
