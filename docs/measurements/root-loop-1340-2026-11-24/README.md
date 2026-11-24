# The common warnings' root loop and -Wunsequenced's marks (buster14a/buster#1340, part 3)

Part 3 of [the plan on #1340](https://github.com/buster14a/buster/issues/1340#issuecomment-7133824505), from
`compile-count-2850-2026-11-24`'s "The parts of the facts and the root walk". The change is
buster14a/buster#3568: base `188cef807`, head `e02c2cb9a`. Everything in `9700x/` is from `benchpress` (the Ryzen 7
9700X) under its lock, CPU 2, the frozen `sqlite3.c` compiled `--lanes 1 -c` with that record's options
(`scripts/roots-ab.sh`): each compiler built as the 9700X job builds it (`scripts/build-one.sh`,
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release`), the variants interleaved in one hold,
`perf stat -r 11` a round, every run's exit status checked and every object compared with the first's.
`scripts/reduce.py DIRECTORY` gives each directory's `reduced.txt`.

## The result (`9700x/final/`, `9700x/final-5/`)

| | base | head | saved |
| --- | ---: | ---: | ---: |
| five rounds (forward, reverse, forward, reverse, forward): ms | 112.02 | 111.09 | 0.93 (0.83, 1.00, 0.68, 1.13, 1.03) |
| five rounds: M user cycles | 546.83 | 541.26 | 5.57 |
| three rounds (forward, reverse, forward): ms | 112.54 | 111.24 | 1.30 (0.38, 2.74, 0.78) |
| three rounds: M user cycles | 548.07 | 540.96 | 7.11 |
| M instructions | 1,266.39 | 1,249.84 | 16.55 |
| k L1 data misses (five rounds) | 18,600 | 18,515 | 84 |

The three-round run's middle round has a base reading of 113.50 ms, an outlier; the five-round run is the steadier
one. `-w` on the base is 100.5 ms. No object differs and no run exited other than 0.

Two builds of one source differ by layout: `9700x/ab-exp-cut5/` has the third cut's compiler at −4.73 M cycles and
the same source with the experiment's switches compiled in and all off at −6.48 M. A difference under about 1.5 M
cycles between two builds is not a finding.

## How it got there (`9700x/ab-*`)

Each directory is one hold; `cutN` are the working tree's states in order, and `exp@MASK` is the state under it with
`scripts/experiment-roots.patch` (throwaway switches, not for merge; `scripts/make-experiment.py` writes it from a
tree) and `BUSTER_EXPERIMENT_ROOTS=MASK`. Less base, M user cycles:

| state | what it is | M cycles |
| --- | --- | ---: |
| `cut3` (`ab-cut3`, `ab-cut3-visits`, `ab-exp`) | every root whose own columns say nothing is left out: 43,938 of 58,722 | −0.8 to −1.1 |
| `cut4` (`ab-cut4`) | and a call's callee's name is asked before its declaration; the unsequenced name filter's range is the wrapper's operand's | −3.2 to −3.5 |
| `cut5` (`ab-cut5`) | and a cast to void is quiet; the marks are made in the classes' pass | −4.7 to −5.2 |
| the head (`final`, `final-5`) | `cut5`'s compiler with the tests and documents | −5.6 to −7.1 |

`cut3` saved 9 M instructions and nothing else: the visits it removed were the cheap ones. The switches on it
(`ab-exp`, `ab-exp-unseq`) say where the loop's 14.4 M cycles were:

| left out (mask) | M cycles less than base |
| --- | ---: |
| nothing (`exp@0`, the cut itself) | −0.3 to −1.0 |
| a call's root quiet without its test (2) | −3.5 |
| a marker's root quiet without its place (4) | −2.6 |
| both (6) | −7.0 |
| every calm root quiet, no root asks the parser or its call (1) | −7.0 to −7.2 |
| no `-Wunsequenced` walk of a candidate (64) | −2.7 |
| no `-Wunsequenced` marks at all (8) | −5.1 to −5.6 |
| every calm root quiet and no marks (9) | −11.1 |
| the loop visits no root (16) | −11.9 |
| nor are the roots classified (32) | −13.4 |
| nor marked (40) | −14.4 to −15.1 |

So of the loop and its marks: the discarded-call test of 6,841 call statements about 2.5 M, the unsequenced
candidates' checks about 2.3 M (1,694 candidates, 1,360 cycles each: the name filter's range ran from a condition's
first node to the condition's root, which stands after its body), the markers' roots about 2.6 M, the marks about
1 M, and the 1,458 roots that reach a candidate about 3 M. `ab-exp-cut4` and `ab-exp-cut5` repeat the switches on
the later states; on `cut5` what is left is the classes' pass with the marks (about 3.5 M, `exp@32` less `exp@16`),
the candidates' checks (1.8 M) and the walks (about 3 M). The ceiling of leaving roots out, with every calm root
quiet for nothing (unsound), is `exp@1`: 7 to 8.5 M cycles, 1.3 to 1.5 ms.

`9700x/prof-cut3/` and `9700x/prof-g/` are `perf record` profiles (`scripts/roots-prof.sh`, eight runs a variant;
`prof-g` with debug information for source lines, `scripts/build-debug.sh`, `scripts/roots-lines.sh`):
`by-line-*.txt` is cycles by source line (multiply by 3.46 for M cycles a run), and `scripts/byfunc.py` sums them by
enclosing function. Function names in `by-symbol-*.txt` are unreliable across builds (the build splits and orders
them); the lines are not.

## Soundness

- `local/corpora-summary.txt` (`scripts/corpora.sh`, a cloud container, Release): base against head over sqlite3.c,
  Lua 5.4.8's 34 units, musl's 1,355 and the c-testsuite's 220, with the default warnings, `-Wall -Wextra` and
  `-Wunsequenced -Wunused-value -Wsign-compare -Wshift-overflow` (`-Wconversion`, asked for, is rejected by the
  compiler as not fully implemented): 4,830 compiles, no difference in any object, status or stderr. With every
  root visited (`BUSTER_TEST_DEFAULT_PATH_LOG`): 662,208 roots, 581,724 quiet, 80,484 loud, none of the quiet whose
  visit acted.
- `9700x/fault/` (`scripts/mutants.py`, `scripts/fault-one.sh`, `scripts/fault-round.sh`): one term of the quiet
  condition or of the order's guard broken at a time, built, and `test-checker-driver --quiet-roots-only` run against
  it; `NAME.txt` is the verdict and `NAME.failures.txt` the failing lines. `first-rounds.txt` is the first two
  rounds' verdicts, of the test before its filler units: `evaluated`, `reach`, `marker-class`, `sole-inner` and
  `repeats-range` first failed to build (an unused variable) and were respelt; `sole-inner` then passed, which found
  that the test's units had no statement root without a discard wrapper (the reader elides it only in units of 8,192
  tokens or more), and the filler units were added. Of 27 mutants 23 fail the section; `comma`, `expression-reach`,
  `wrapper-modification` and `repeats-body` pass, each redundant with another term (the pull request says how).

## Against main as merged into the branch (`9700x/merged/`, `9700x/merged-5/`)

Main moved while the change was made (buster14a/buster#3553, #3564, #3560 and others). The branch merged main
`85a032f88`; base `85a032f88`, head `36b225e7b`, built and run as above.

| | base | head | saved |
| --- | ---: | ---: | ---: |
| five rounds: ms | 114.80 | 114.11 | 0.69 (0.55, 0.84, 0.97, 0.39, 0.69) |
| five rounds: M user cycles | 560.75 | 556.94 | 3.80 |
| three rounds: ms | 114.83 | 114.98 | −0.14 (0.39, −1.49, 0.67; the head's middle round read 116.51) |
| M instructions | 1,265.38 | 1,248.83 | 16.55 |

The merged main's own compile is 2.8 ms slower than `188cef807`'s (114.8 against 112.0 ms; `-w` is 100.8 in
both), which is not this change's. The compile's count (tools/ci/compile-count.sh, a cloud container): 312,364,833
to 306,853,284, −1.76%.
