# Frozen #590 target qualification

Baseline `bc1b486150850fe00bad1361a19f57d67706bb3b`; candidate
`8b815992da557a33b91c5efee809723d4e7f2df6`. This report applies only to
these frozen revisions. The native release build passed all 41 units and
`test-check-lanes --seed 590 --programs 1` passed 2,335 checks, including
150 cold/warm/reusable-caller startup checks, with zero failures. See
`native-build.log` and `native-lanes.log`.

All target work used the shared exclusive lock per bounded invocation on
the Ryzen 7 9700X. Timing processes use CPU 2. Full compiler/TCC/source
identities, native Clang 23.1.1, THP settings and raw status are retained.
No host settings changed. The host remained THP `always`; `thp_off.c` uses
PR_SET_THP_DISABLE only in its own process, verifies PR_GET_THP_DISABLE and
executes the compiler. `thp-disabled-status.log` proves exec inheritance
with `THP_enabled: 0`. This is a per-process base-page control, not a claim
to have measured a host changed to `madvise`.

The original C `samples`/`cohort` collectors run each input/mode separately,
11 rotated base/head rounds, one task on CPU 2, `-c --time-stages INPUT -o
@OUTPUT@` with the normal driver defaults. There are no warmups or dropped
first samples. The
strict original C `stage_summary.c` reads each compiler's raw stage clock,
its rusage, and the collector elapsed time, and compares every object pair.
The elapsed collector clock includes fork, affinity and capture overhead;
it is not uninstrumented compiler latency. All 220 compiler processes
returned 0 and all 110 object pairs were byte-identical. Raw first-run major
faults are retained: default empty candidate total 9 and default data
candidate total 2; every other stage cohort had zero major faults.

| Mode/input | Base backend setup ms | Head backend setup ms | Base setup minor faults | Head setup minor faults |
| --- | ---: | ---: | ---: | ---: |
| default empty | 0.600 | 0.000 | 11 | 0 |
| default initialized data | 0.595 | 0.000 | 9 | 0 |
| default dropped static body | 0.593 | 0.000 | 11 | 0 |
| default tiny function | 0.593 | 0.595 | 10 | 10 |
| default hello | 0.594 | 0.596 | 9 | 9 |
| THP disabled empty | 0.908 | 0.000 | 1,099 | 0 |
| THP disabled initialized data | 0.898 | 0.000 | 1,097 | 0 |
| THP disabled dropped static body | 0.914 | 0.000 | 1,099 | 0 |
| THP disabled tiny function | 0.889 | 0.887 | 1,098 | 1,098 |
| THP disabled hello | 0.883 | 0.884 | 1,097 | 1,097 |

These medians and stage peak-added RSS show that table setup is absent
when there are no selected bodies in both page-policy controls. The default
empty cohort wall is 1.438414 to 0.820667 ms (paired -43.06%); the disabled
control is 1.914626 to 0.912108 ms (-52.20%). Function-bearing controls keep
the setup and are neutral at this resolution. Tiny default process RSS is
21,944/21,968 KB; hello is 22,216/22,188 KB. The laptop's layout-dependent
3.4 MiB body RSS increase did not reproduce on the native target.

Separate uninstrumented head/TCC comparisons use one input and two roles
per invocation, 41 rotated rounds, three warmups and one copy. All 246
timed processes returned 0 with zero major faults. `tcc-pair-analysis.txt`
retains all statistics and raw receipts. Common arguments are only
`-c INPUT -o OUTPUT`, without `--time-stages`.

| Input | Candidate median wall ms | TCC median wall ms |
| --- | ---: | ---: |
| empty | 0.765 | 0.361 |
| hello | 1.467 | 0.381 |
| pinned c-testsuite 00001 | 1.432 | 0.376 |

TCC remains faster on these tiny inputs. This fix removes one large
startup source only for units without emitted bodies; it does not claim
to close the body-bearing startup gap. Encoder table formats and hot
lookups are unchanged. Cold/warm state, failures, unwind, scalar/vector,
drop-selection and reuse have permanent coverage, including a mutation
that restores the original bug and fails 32 assertions locally.

The earlier six-list/three-build `small-tcc-ab.log` remains as contextual
raw evidence. It is superseded for causal tiny timing interpretation:
mixed-list global rotation preserves predecessors and produced an
identical-binary bias, documented in `../../evidence-652/target/ORDER-METHOD.md`.
The one-input stage and TCC campaigns avoid that cross-input pattern.

No PR, push, issue comment or shared host setting change was made.

The packaging-overlap audit in `../../evidence-652/target/contamination-audit.md`
screens all four parent-reported windows. No accepted #590 cohort overlaps
them within conservative clock bounds; no replacement was needed.
