# Frozen #657 target qualification

Baseline source `bc1b486150850fe00bad1361a19f57d67706bb3b`; candidate
`086c24b121e4834b821a47974069d2af8b9ed2fc`. The candidate includes the
production bound, observable deep-work test boundary, and zero-region
null-metadata regression. These results apply to these frozen revisions,
not a later integration or current-main merge.

On the shared Ryzen 7 9700X, the exact candidate's native release build
passed all 41 units and `test-checker --seed 657` passed 392,578 checks with
zero failures (`native-build.log`, `native-checker.log`). Native Clang is
23.1.1. The four laptop fpclassify oracle disagreements did not occur here.
The source archive digest, full executable identities, CPU/THP settings and
build receipts are retained beside this report.

All remote builds, tests, measurements and artifact exports used the shared
exclusive lock, one bounded invocation per hold. The original C `samples`
and `cohort` collectors in `../../campaign/` rotate base/head order each round.
Each case is a separate invocation with 11 rounds, one job, one task, CPU 2,
`--lanes 1 --time-stages -c INPUT -o @OUTPUT@`. Every fresh process has its
own complete stage stderr, rusage row and object. There were no warmups or
discarded first samples in these stage cohorts. The collector's elapsed
time includes fork, affinity and output capture; it is not an uninstrumented
compiler latency measurement. Stage clocks are the compiler's own clocks.

`stage_summary.c` is an original strict C analyzer. It requires exactly one
successful child on CPU 2 per receipt and compares every object pair. It
reads the stage clock and the collector's wall time; it does not synthesize
hardware counters that were not recorded. All 110 compiler processes
returned 0, all had zero major faults, and all 55 base/head object pairs were
byte-identical. Every outlier remains in `raw/qa657-086c24b1/`.

| Original generated case | Base check-input ms | Head check-input ms | Base cohort wall ms | Head cohort wall ms |
| --- | ---: | ---: | ---: | ---: |
| plain switch, depth 1,000 | 3.111 | 1.082 | 7.377330 | 5.282125 |
| plain switch, depth 4,000 | 34.464 | 5.305 | 44.308454 | 15.081756 |
| plain switch, depth 16,000 | 508.544 | 23.359 | 541.031530 | 55.244346 |
| switch in statement expression, depth 16,000 | 516.750 | 24.900 | 553.854867 | 58.719733 |
| local gotos in statement expression, depth 16,000 | 130.889 | 15.179 | 266.233554 | 150.450664 |

Values are separate medians. Paired cohort-wall changes are -28.63%,
-66.25%, -89.85%, -89.38% and -43.51%; all 11 pairs per case favor the
candidate. The plain scaling moves from quadratic toward linear, and the
region-wrapped cases exercise the shared-ancestor bound beyond the
zero-region fast return. This is targeted deep-input evidence, not a claim
of general corpus throughput improvement. Permanent fixtures cover legal
and illegal jump boundaries, and exhaustive token pairs compare against
the unchanged scalar full-parent-walk oracle.

The separate current-main merge adapts this optimization to the reader's
shared `subtree_sizes` metadata because #640 permits `Parser.sizes == NULL`.
That compatibility work and its normal/tree-only tests were accepted into
`a4be8afa86d2e3e6d69ef00024e5e25c06ae6b5e`; its integration tests are
recorded by the merge owner. No timing in this report is assigned to it.

Reanalysis from the workspace root:

```
clang -std=c17 -O2 -Wall -Wextra -Werror work/evidence-657/target/stage_summary.c -o work/evidence-657/target/stage_summary
work/evidence-657/target/stage_summary work/evidence-657/target/raw/qa657-086c24b1/switch-plain-16000 11 check-input
```

No PR, push, issue comment or shared host setting change was made.

The packaging-overlap audit in `../../evidence-652/target/contamination-audit.md`
screens all four parent-reported windows. No accepted #657 cohort overlaps
them within conservative per-process clock bounds; no replacement was needed.
