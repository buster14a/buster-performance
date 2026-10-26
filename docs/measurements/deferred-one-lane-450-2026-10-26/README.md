# One-lane deferred readings without affinity calls (#450)

Manual qualification passes for exact baseline `35f26f68d7caa9bf5f6248822100a51c06e2c878`
and candidate `1d2b12c658807f466b989bcdfe2cdf548c1812d5`. One active lane uses the
existing `lane_run_cold(1, ..., NULL)` utility, preserving the lane context,
unfinished take and running state with a fresh isolated group. It creates no
worker or affinity calls. Multiple lanes keep the fixed team and CPU list;
generic lane validation/refusal contracts remain unchanged.

Scope: [#450 claim](https://github.com/buster14a/buster/issues/450#issuecomment-6413009928),
delivery branch `codex/450-one-lane-dispatch`. Arena retention, costliest-part
scheduling and the lane-count rule remain outside this change. Exact35 includes
merged #449 and current checker fixes; later unrelated revisions are outside
this manual comparison. Submitted-head integration CI is a separate gate.

Delivery [PR #498](https://github.com/buster14a/buster/pull/498), signed head
`00a63096f77f435fcf59ad8b531a12bd997e2f30`, passes all three CI checks,
including the native job in [run 40375078592](https://github.com/buster14a/buster/actions/runs/40375078592).
Its source/build/CI trees are identical to measured `1d2b12c6`; only final
documentation changed. The [exact-head receipt](cold/ci-submitted-head.json)
and [delivery proof](cold/delivery-proof.md) preserve that distinction.

| SQLite metric | Before | After |
| --- | ---: | ---: |
| One-lane dispatch | 7,204 ns | 391 ns |
| Whole checker, one lane | 120.29 ns/token | 119.66 ns/token (−0.5237%) |
| Whole checker, adaptive eight | 104.09 ns/token | 103.84 ns/token (−0.2402%) |

Small-program dispatch is 30–40 ns; one-lane wake remains zero. Whole-reader
timings exclude preprocessing/startup and the separately reported parse.
Instruction counts and whole-process RSS are not outputs of this harness.
No general multi-lane dispatch improvement is claimed.

The original thirteen-case five-pair set and 219-program single-pair screen
were followed by a predeclared five-pair repeat of every eligible corpus unit.
All 2,758 independent processes pass; 226 identities match initial/before/after.
The six actual measurement holds last 37/24/1/2/3/36 seconds, below the approved
60-second cap. The existing shared host lock, 24 passes, six reading orders,
CPU affinity and frozen options are preserved.

The confirmation has 33 positive build-median ratios, at most +1.5749%, and
34 positive paired medians. None is slower in all five pairs. Original adverse
observations, including 00066.c's +2.2499% median, remain separate and visible;
they are neither pooled away nor waived by source-order normalization. The
protocol detects no repeatable measurable regression; it does not show every
individual sample improves or prove a universal zero effect.

- [Complete accepted methods, exact revisions/images, results and interpretation](cold/README.md).
- [Initial raw observations](cold/raw/), [rows](cold/rows.tsv), [summary](cold/summary.tsv).
- [All-corpus confirmation raw observations](cold/confirmatory/raw/), [rows](cold/confirmatory/rows.tsv), [summary](cold/confirmatory/summary.tsv).
- [Local sanitizer/graph proof and reproducible harness](cold/local-validation/README.md), [native acceptance](cold/acceptance/), [native code generation](cold/codegen/).
- [C reader](summary450.c) and [independent byte-identical replay](cold/confirmatory/reader-validation.md).
- [Resource budgets, actual lock, FIFO campaign order and corrected early allocation](../coordination-449-450-451-2026-10-26/README.md).

Earlier correctness-passing candidates failed timing acceptance. Their evidence
is retained rather than used to qualify this different source pair:

- [Original direct-context prototype and outlined helper](direct-context-README.md), root [prototype raw](raw/) and [helper raw](final/raw/).
- [Existing deferred-phase outline](outlined/README.md).
- [Generic singleton-affinity check](affinity/README.md), including all six generic lane tables and their adverse observations.

The accepted production change reuses the existing launcher; it adds no lane
API, external implementation or dependency. The lane implementation and its
MIT/RAD Debugger notices remain unchanged. Checker/test additions are original C.
