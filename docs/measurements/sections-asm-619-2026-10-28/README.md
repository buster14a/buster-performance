# `-c`'s named sections and file-scope `asm`: what they cost, 2026-10-28

Branch `claude/loving-carson-j9sz52-sections` (buster14a/buster#716) is #619's part 2. It puts `-c`'s and the direct
path's definitions in the sections their `section` attributes, or `#pragma clang section`'s text setting, name. It
also assembles file-scope `asm` into atoms of their sections. This record measures the pull request's commit
`0cf1abd4` against its base, #700's head `93d232b8` at the time, with an A/A control: a copy of the base's executable.
It covers two inputs:

- the frozen `sqlite3.c`, which names no section and has no file-scope `asm`;
- a generated unit with and without named sections.

The pull request's later heads aren't measured here. From `4fcf8f60` on, they carry the review's three corrections and
main `20f6cdc5`.

| Measure (`sqlite3.c`) | base (`93d232b8`) | A/A control | head (`0cf1abd4`) | head against base | control against base |
| --- | --- | --- | --- | --- | --- |
| `-fsyntax-only`, user instructions (`perf stat`) | 996,068,279 | 996,068,296 | 996,066,443 | -1,836 (-0.0002%) | +17 |
| `-fsyntax-only`, user cycles | 468.335 M | 468.054 M | 468.182 M | -0.03% | -0.06% |
| `-fsyntax-only`, wall (`time-runs`) | 102.340 ms | 102.436 ms | 102.380 ms | +0.04% | +0.09% |
| `-fsyntax-only`, peak resident set | 374,980 KB | 374,980 KB | 375,100 KB | +120 KB | 0 |
| `-c`, user instructions | 1,257,303,112 | 1,257,303,112 | 1,257,402,838 | +99,726 (+0.008%) | 0 |
| `-c`, user cycles | 587.895 M | 588.714 M | 586.434 M | -0.25% | +0.14% |
| `-c`, wall (`time-runs`) | 125.074 ms | 125.126 ms | 124.875 ms | -0.16% | +0.04% |
| `-c`, peak resident set | 389,276 KB | 389,276 KB | 389,648 KB | +372 KB | 0 |

Where the rows come from:

- The `perf stat` rows are the medians of three rounds of `-r 11`, the three executables in a rotating order
  (`perf.log`).
- The `time-runs` rows are the medians of five `ab` rounds of 11 processes each (`ab.log`).
- All three executables' `-c` wrote the same object (`ab619s2.log`: "lower objects identical"; `inputs.sha256`).

The A/A control bounds what the comparison can resolve:

- **`-fsyntax-only`:** the head's instructions are the base's within 1,836 (0.0002%). Its cycle and wall differences
  are smaller than the control's own.
- **`-c` instructions:** the head runs 99,726 more (+0.008%). With `-fsyntax-only`'s the same, they come from what
  `-c` runs past checking: the emission, whose section pass returns at once for a unit without placements or
  file-scope `asm`, and the object writer, whose sections' count and layout the branch restructured (below).
- **`-c` cycles and wall:** the head is lower in all five paired `ab` rounds, by 0.03% to 0.31%. But the identical
  executable's rounds range from -0.26% to +0.13% against the base, so this record claims no speedup, and no cost
  either.

`main.c` with `build.sh`'s flags:

- The base's `-c` stops at `main.c:341:1: error: unsupported: file-scope assembly` (`main_c_lower_base.log`).
- The head's `-c` gets past it and the checker's section pragma. It stops at `xmmintrin.h:1496:24: error: unsupported:
  vector types` (`main_c_lower_head.log`), which #136's vector producer (buster14a/buster#717) takes next.
- The head's `-fsyntax-only -Wall -Werror` of `main.c` succeeds (`main_c_check_head.log`, status 0).

## Named sections in a compile

`ab619s2.sh` generates a unit of 20,000 external functions and 2,000 initialized variables, in two versions:

- `sections_plain.c`: as generated;
- `sections_named.c`: every function but each fourth in `.text.hot` or `.text.unlikely` by turns, and every variable
  but each fourth in `.data.tables`.

The head compiled each with `-c`, in four rounds of `perf stat -r 11` in a rotating order (`sections_perf.log`):

| Measure | plain | named | change |
| --- | --- | --- | --- |
| user instructions | 687,731,889 | 862,720,188 | +174,988,299 (+25.4%) |
| user cycles | 198.015 M | 290.194 M | +46.6% |
| task-clock | 45.225 ms | 64.185 ms | +41.9% |
| tokens | 310,000 | 458,500 | +148,500 (+47.9%) |
| bytes | 891,563 | 1,548,063 | +656,500 (+73.6%) |
| instructions per token | 2,218.5 | 1,881.6 | -15.2% |
| cycles per token | 638.8 | 632.9 | -0.9% |

(Each median of four rounds is the mean of the middle two.)

The comparison isn't token-matched. The named unit's 16,500 attributes, `__attribute__((section("...")))`, add 148,500
tokens and 656,500 bytes that the plain unit doesn't have, and per token it cost about the same cycles as the plain
one. So this measures the attributes and their sections together, and it can't separate what the sections themselves
cost (the reader's placements, the emission's descriptors, the object writer's groups) from what reading the tokens
costs. A control with the same attributes naming `.text` and `.data`, the classes' own sections, which make no new
section, would separate them. This record doesn't have one.

Both objects have the sections clang's object has (`sections_*.readelf`): `.text.hot` and `.text.unlikely` (`AX`,
aligned to 16) and `.data.tables` (`WA`, aligned to 4), beside the remaining `.text` and `.data`.

## The object writer

`benchmark-object-writer` builds 64 objects of synth's shape without named sections. It ran in six rounds, the base
and the head in turn (`object_writer.log`); the medians per object, over the rounds' medians:

| Measure | base | head | change |
| --- | --- | --- | --- |
| build, instructions | 267,696 | 269,929 | +2,233 (+0.83%) |
| build, cycles | 74,092 | 72,958 | -1.5% |
| build, time | 13.37 µs | 13.16 µs | -1.6% |
| prepare, once for the link | 96.19 µs | 92.85 µs | -3.5% |
| object in place, in all | 42.61 µs | 41.28 µs | -3.1% |
| object in a new file, in all | 53.93 µs | 53.31 µs | -1.1% |

Without `ObjectOptions.atom_sections`, `object_group_atoms` doesn't run. So the 2,233 instructions are the
restructured count and layout of each class's sections, which now go through groups and an atom order. This benchmark
had no A/A control in the run, so its cycle and time differences aren't attributed.

## Tests

On the 9700X, against the system clang 23.1.1 with the oracle cache off, the head passes (`test_*.log`):

- `test-object-writer --cross-check`;
- `test-assembler --cross-check` (1,891,352 checks);
- `test-checker-driver --executable ./build/compiler` (22,434);
- `test-checker-deferred` (84 fixtures, 1,489 checks);
- `test-check-lanes` (2,721) and `test-check-debug --cross-check` (2,534);
- `test-import --cross-check`;
- `test-c-testsuite --cross-check` on the subset (220 of 220);
- `test-checker-corpus` on the frozen musl directories (574 files accepted as clang accepts them, and 354 objects
  compared by their symbols with `clang -O0 -c`'s, the minimum the job sets) and on `sqlite3.c` with `--deferred 8
  --symbols`;
- `benchmark-lowering-source` on c-testsuite's programs.

`test-checker --seed 133` reports 464,972 checks and 4 failures (`test_test-checker.log`). They are two programs,
each on both paths, whose oracle is clang's order of side effects in `__builtin_fpclassify`'s selectors:
`fpclassify-conditional-selector-effects` (`n=2`: ours 512344, clang's 512434) and
`fpclassify-known-category-effects` (`n=-3`: ours 1512340, clang's 1512430).

Clang's code generation evaluates the normal and subnormal selectors as two arguments of one C++ call, an order C++
leaves to whichever compiler built clang. Main's #678 (`0ef179b`, which the base and the head both contain) changed
this compiler's order to the official Clang 23.1.4's, normal first, from the 9700X's GCC-built Clang 23.1.1's,
subnormal first. #678 also moved the 9700X's CI job to a staged official 23.1.4, which this run didn't use.
`fpclassify-order.c` is the conditional fixture as a program; each clang's output for `n` from -1 to 3:

- the 9700X's clang 23.1.1, under the lock: 511, 55, 5122, **512434**, 512433;
- clang 23.1.5 (Ubuntu's, on the cloud VM that wrote this record): 511, 55, 5122, **512344**, 512343.

Ours gives 512344. No line of the diff from the base to the head names fpclassify, so the base would fail the same
tests against this clang. That is inferred: the base's `test-checker` didn't run. #717's record
(`../vectors-producer-136-2026-10-28/`) shows the other side: its head predates #678, and it passes these tests against
the same clang 23.1.1.

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`93d232b8`](https://github.com/buster14a/buster/tree/93d232b80ee4b6d863c3c7d0988572cb6bfdebbd) | #700's head when measured, which merges main `12db4a0e` |
| `head` | [`0cf1abd4`](https://github.com/buster14a/buster/tree/0cf1abd48c70997d3b5f227ed7668cea96d95892) | the measured head of #716 |
| `control` | `base`'s executable | `cmp` equal to it (`ab619s2.log`), at another path |

Each tree was `git archive` of its commit, sent by tar into an empty directory. Each `source-*.sha256` holds the
SHA-256 of every file of its tree but `build/`, 681 files each, all of which match `git archive` of the full commit
above. `inputs.sha256` holds those of the executables, the objects, the generated units, the input and its
predefines, and the host's kernel and clang. Each tree was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh`
(`build_*.log`), in 29.1 and 29.2 s.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1.

## Method

`ab619s2.sh` ran everything; `ab619s2.log` is its output. The inputs and options are those of
[#619's first record](../checker-pragmas-619-2026-10-28/README.md): the preprocessor oracle's frozen
`sqlite/sqlite3.c` with the pinned gnu17 predefines, `-march=znver5 -std=gnu17 -nostdinc` and the corpus's system
directories, `SOURCE_DATE_EPOCH=1792454400`, `CPATH` and `C_INCLUDE_PATH` unset. `-fsyntax-only` runs with
`--clang-features` and `-c` without it.

Each build, test and timed run took the shared lock on its own through the script's `locked`, and `ab` took it per
run through `lock-receipt.sh`. Every acquisition and release wrote a receipt line with the time and CPU 2's governor,
energy preference, frequency bounds, boost and driver (`receipts.log`). All 152 lines (76 holds) read
`governor=performance epp=performance min=605310 max=5582301 boost=1 driver=amd-pstate-epp`. Each release has its run's
status: 0, but for the three runs that fail as reported above, each tree's `-c` of `main.c` and `test-checker`.
Nothing is filtered from the logs: the lock's waiting messages, which name the other sessions' and CI's runs it
waited for, are in them. The timed runs ran pinned to CPU 2, and the suites on CPUs 0 to 7, as the job runs them.

## Limits

- One input for the cost, `sqlite3.c`, with one placement per tree. The A/A control covers `sqlite3.c`'s rows only.
- The named-sections comparison isn't token-matched (above).
- The object writer's rows have no A/A control.
- The suites ran against the system clang 23.1.1, not the official 23.1.4 that the CI job now stages, which accounts
  for the 4 fpclassify failures.
- No profile was taken.
- The pull request's later heads, with the review's corrections (descriptors validated before grouping, the first
  section attribute within a declaration, the lanes benchmark's warm-ups) and main `20f6cdc5`, are not measured here.
