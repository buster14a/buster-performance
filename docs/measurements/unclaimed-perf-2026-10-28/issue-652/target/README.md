# Frozen cleanup-only #652 target qualification

Baseline `bc1b486150850fe00bad1361a19f57d67706bb3b`; cleanup-only candidate
`24e9c1f8d9c8fb32d06768b08cd6867d1252bc32`. The rejected 1 MiB arena-prefix
experiment is absent. Exact native binaries and corpus identities are in
`native-identities.log`; host details are in `hardware.txt`. All builds,
tests, timings, syscall controls and exports used the shared exclusive
lock per bounded invocation. Scalar timings use CPU 2. No host settings
were changed. These are frozen-revision measurements, not integration
performance claims.

An initial mixed-list measurement was invalid for causal tiny timing:
global ordinal rotation preserves most predecessors. A complete 41-round
same-binary A/A gives a spurious -25.91% empty syntax change. The exact
setup, source-level mechanism, raw invocation and inference limits are
retained in `ORDER-METHOD.md` and `aa.log`. Original mixed receipts are
preserved, not used as accepted tiny speedups. The shared profiling source
was not changed by this work.

The superseding accepted controls use one input per invocation, 41 rounds,
three warmups, one copy, and two roles, with matched A/A, A/B and reversed
B/A. Across the odd number of rounds this balances own/other-role
predecessors. Commands are empty `-fsyntax-only`, empty `-E -P -o /dev/null`,
and tiny `--lanes 1 -c -o OBJECT`. The analyzer is original C `time_pairs.c`;
it retains every failed/major-fault row, computes each round's paired ratio,
and prints a seeded 10,000-resample percentile interval. All 738 timed
processes in these nine isolated campaigns returned 0 with zero major
faults.

| Input/control | Base median ms | Candidate/control median ms | Paired wall change | Bootstrap 95% interval |
| --- | ---: | ---: | ---: | ---: |
| syntax A/A | 0.665 | 0.666 | 0.00% | [-0.48%, +0.59%] |
| syntax A/B | 0.673 | 0.580 | -14.06% | [-14.61%, -13.51%] |
| syntax B/A | 0.664 | 0.575 | -13.24% | [-13.86%, -13.05%] |
| preprocessing A/A | 0.528 | 0.528 | 0.00% | [-0.37%, +0.75%] |
| preprocessing A/B | 0.535 | 0.468 | -12.29% | [-12.81%, -11.80%] |
| preprocessing B/A | 0.530 | 0.466 | -12.26% | [-12.76%, -11.83%] |
| tiny object A/A | 1.405 | 1.399 | -0.36% | [-0.78%, -0.14%] |
| tiny object A/B | 1.415 | 1.318 | -6.67% | [-8.07%, -5.77%] |
| tiny object B/A | 1.418 | 1.325 | -6.40% | [-7.91%, -5.61%] |

The ~13–14% syntax, ~12% preprocessing and ~6.4–6.7% tiny object improvements
are larger than their matched A/A effects and survive role reversal.
Elapsed time is the whole process, including kernel teardown on exit.

SQLite uses the frozen pinned-predefine/header corpus and flags recorded
line by line in `raw/qa652-24e9c1f8/base-sql.argv`. Initial 31-round A/B
medians are 144.054/143.271 ms, paired -0.403%; reversed 31-round medians
144.228/143.538 ms, paired -0.496%. The retained same-binary mixed A/A gives
-0.294%. Peak RSS is 517,144 KB on both builds in both A/B runs. All SQLite
timed processes returned 0 with zero major faults. These small changes are
treated as a neutral large-input control, not a qualified SQLite speedup.

`strace -f -c -e trace=mmap,madvise,munmap` runs, each separately locked,
preserve explicit argv and exit files. All eight compiler runs returned 0.

| Case | mmap base/head | madvise base/head | munmap base/head |
| --- | ---: | ---: | ---: |
| empty syntax | 92 / 92 | 144 / 144 | 79 / 0 |
| nonempty tiny preprocessing | 74 / 74 | 123 / 123 | 61 / 0 |
| tiny object | 95 / 95 | 149 / 149 | 82 / 3 |
| SQLite object | 106 / 106 | 164 / 164 | 92 / 3 |

Tiny and SQLite object bytes, plus nonempty preprocessor output bytes,
match baseline (`equality.txt`). The raw `.stderr` receipts contain only
exclusive-lock wait notices; they must not be compared as compiler
diagnostics. No compiler diagnostic appeared. Reusable-call and allocation
failure correctness is covered by the candidate's local 21,644/0 driver,
parser/Clang and call-graph passes, and by the parent native integrated
qualification; these are separate from timing evidence.

No PR, push or issue comment was made.

`contamination-audit.md` screens four parent-reported unlocked packaging
windows. Accepted isolated tiny, stage and SQL controls lie outside them.
The old mixed A/A and two syscall receipt brackets are conservatively
annotated where exact overlap is unknown. No accepted performance result
depends on those potentially overlapping brackets; no replacement was needed.
