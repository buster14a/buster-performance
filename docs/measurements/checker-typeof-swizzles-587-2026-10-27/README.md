# Extension-vector swizzles in `__typeof__` (#587)

Qualification and default-workload measurements for
[Buster #587](https://github.com/buster14a/buster/issues/587), implemented in
[PR #589](https://github.com/buster14a/buster/pull/589).

- Frozen base: `74dae999734fa0423efcc198af2ebd6251cc8108`.
- Fix: `0d4148e43a0f258fb68ef98172c5b5122951d04e`.
- The regression build uses the base implementation of `c_check_constant.c`
  with the head's new test fixtures. Performance builds restore both source
  files to their respective revisions, so the base performance build is the
  original frozen base.

The change supplies the existing vector-member semantic action with a decoded
swizzle during declaration-time type queries. It reuses the existing decoder,
lane validation, result type construction and qualifier rules.

## Qualification

The new `test-checker` fixtures cover every input width from 2 through 16,
including odd widths, and lane lists whose result widths span 2 through 16.
They assert scalar, pair, full-vector and half-vector types, including the
scalar halves of two-lane inputs. Coordinate, color and numeric spelling,
duplicate lanes, `lo`/`hi`/`even`/`odd`, nested record and pointer-to-record
members, chained selections, rvalues and qualified float elements are covered.
Four invalid fixtures retain rejection. Clang independently checks all source
fixtures; both scalar and vector checker schedules check the same assertions.

On the Ryzen 7 9700X, the unfixed implementation with the new tests reports
259,802 checks and 68 failures: all 17 new positive fixtures fail both their
expected-acceptance and Clang-agreement assertions on both schedules. The four
new invalid cases retain their expected rejection.

The patched, frozen source passes the same 9700X suite against Clang 23.1.1:
259,887 checks, zero failures. The added checks include the successful graph
and initializer stages that the unfixed implementation could not reach.
The same source also passes `test-checker-deferred` (960 checks) and
`./build.sh check-call-graph` (41 units, 23,840 functions, 142,661 calls, no
unallowed cycles or split variables). All build/test return codes are retained
beside the corresponding logs under `results/`.

[Required CI run 40544404235](https://github.com/buster14a/buster/actions/runs/40544404235)
also passes, including the full test stage and affected benchmarks. Its actual
checkout is the integration commit `32bab0416421d9f220bb3422cfa74588fb3fba55`
(head `0d4148e4` into main `782d3cbb`), distinct from the separately tested frozen
source. Its checker reports 259,887 checks and zero failures; its deferred
checker reports 960 checks and zero failures; its call graph reports no
unallowed cycles or split variables. The decoded job log is retained as
`ci-40544404235.log`.

Local Clang 23.1.4 validation has these separate results:

- Optimized `./build.sh` succeeds.
- Direct `-fsyntax-only -march=znver5` runs agree with Clang on all 17 valid and
  four invalid new fixtures.
- `test-checker-deferred`: 960 checks, zero failures.
- `./build.sh check-call-graph`: 41 translation units, 23,840 functions,
  142,661 calls, zero unallowed cycles and zero split variables.
- Full `test-checker --seed 133`: 259,887 checks, four generated-code/Clang
  mismatches in `fpclassify-conditional-selector-effects` and
  `fpclassify-known-category-effects`. There are no swizzle failures. This local
  full-suite run does not pass; its log is retained in `local-checker.log`.

### Review follow-up: classify the four local mismatches

The [review of PR #589](https://github.com/buster14a/buster/pull/589#pullrequestreview-5671114683)
requested a baseline/regression classification. A fresh optimized build of the
unmodified frozen base, and a repeated head run, use the same local Clang
23.1.4 and `test-checker --seed 133`. Builds run through `cores -n 4` with
`BUSTER_DEBUG_INFO=0`; each checker run uses `cores -n 1`.

| Source | Checks | Failures | Exit status |
| --- | ---: | ---: | ---: |
| Original base `74dae999` (original fixtures) | 259,613 | 4 | 1 |
| Head `0d4148e4` (includes new swizzle fixtures) | 259,887 | 4 | 1 |

Both reproduce exactly the same failures on both checker schedules:

- `fpclassify-conditional-selector-effects`, `n=2`, repeat 0:
  Buster 512434 versus Clang 512344.
- `fpclassify-known-category-effects`, `n=-3`, repeat 0:
  Buster 1512430 versus Clang 1512340.

The extracted failure signatures compare byte-for-byte equal. These are
**pre-existing baseline failures under the local toolchain, not regressions
introduced by #589**. This classification does not turn either local full-suite
run into a pass and does not diagnose which compiler or fixture is responsible.
The separate passing 9700X results above remain the target-host acceptance.

`review/` retains the baseline build, both complete checker logs, source and
local tool/CPU/binary identities, failure signatures, and commands. The compiler
head is unchanged; no repeated hardware or timing campaign was needed for this
evidence-only follow-up.

## Measurement method

Both builds use the approved host's Clang 23.1.1, the existing `./build.sh`,
`-O3 -march=native`, the repository's remaining flags, and
`BUSTER_DEBUG_INFO=0`. Every build, test and measurement separately takes
`~/buster-fast-bench/exclusive.sh`. Measurements are pinned to CPU 2.

The workload is `-fsyntax-only` of the host's frozen
`~/buster-fast-bench/refine-claude/inputs/sqlite3.c`. The input and executable
hashes, CPU and tool identities are retained in `results/identity.log`.

`measure.sh` builds six placements per revision, shifting `main_unit_checker.c`
by 0, 688, 1,376, 2,064, 2,752 and 3,440 bytes. The existing `time-runs` tool
makes three fresh equal-length-path copies per placement, rotates the order of
base, head and repeated-base runs, warms each executable, and collects three
samples per copy in each of three independently locked rounds. This is 54
timed processes per revision per round, plus 54 for the repeated-base control.
User cycles/instructions, wall/user/system time, RSS and faults are retained.
No timing is taken from a refused swizzle program.
Copies and test temporaries use the host work directory (`TMPDIR=$PWD/tmp`).

This default-workload comparison is not a vector-query throughput benchmark.
The correctness tests establish support for the newly accepted programs.

## Results

All 486 timed processes exit successfully, have nonzero user-cycle and
instruction counts, and have zero major faults. Every round contains exactly
54 uniquely identified samples per build. The original C receipt reader
`summarize.c` validates these conditions before producing `summary.csv`.
It also rejects the incomplete two-round log. The existing `time-runs` reports
and the independent receipt reader agree on the cycle and wall-time medians.

| Round | Base wall (ms) | Head wall (ms) | Wall change | Base cycles (M) | Head cycles (M) | Cycles change | Repeated-base cycles change |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 128.504 | 128.308 | -0.15% | 576.226 | 574.851 | -0.24% | -0.04% |
| 2 | 128.561 | 128.482 | -0.06% | 575.112 | 574.641 | -0.08% | -0.07% |
| 3 | 128.105 | 128.180 | +0.06% | 574.992 | 574.215 | -0.14% | +0.38% |

The repeated-base wall changes range from -0.07% to +0.31%. Across placements
and fresh copies, the head/base cycle comparisons span both signs in every
round (from -1.98% to +1.81% in round 2). These data do not resolve a timing
change; no throughput improvement is claimed.

Instruction medians are 1,374,790,595 for the base in all three rounds, versus
1,374,785,532 / 1,374,785,531 / 1,374,785,535 for the head: 5,060–5,064 fewer
instructions, under 0.0004%. Peak-RSS medians are 593,068–593,072 KiB for the
base and 592,804–592,828 KiB for the head. Minor-fault medians are 1,619 and
1,615 respectively. The complete resource rows are in `summary.csv` and the
raw log; these small resource differences are not extrapolated to other inputs.

All head tracked-file hashes verify after the builds. The input and all
recorded executable hashes also match before and after measurements
(`results/identity.log` and `results/post-identity.log`).

## Reproduction and provenance

Use a dedicated copy of the compiler tree at the fix revision in
`~/buster-fast-bench/issue587-codex-20261027`, since the scripts temporarily swap
the two changed source files. Obtain `c_check_constant.base.c` and
`c_check_vector_test.base.c` with `git show BASE:src/buster/compiler/FILE` from
the frozen base above. Copy `qualify.sh`, `measure.sh`, `source-info.txt` and
`source-files.sha256` from this record to that directory. Run `bash qualify.sh`
and then `bash measure.sh`. The head's tracked-file hash manifest is checked
after restoring the head for measurements.
To regenerate the summary locally, compile `summarize.c` with
`clang -std=c17 -O2 -Wall -Wextra -Werror` and run the resulting executable on
`results/sqlite.log`. It emits the nine median rows only for a complete campaign.

Reports and scripts are original material under Apache-2.0 WITH LLVM-exception.
Clang is an external behavior oracle, and SQLite is an external runtime input;
neither implementation nor corpus is incorporated here. Compiler sources are
identified by their existing repository revisions rather than copied into this
record. Raw logs retain warnings and negative qualification outcomes.
