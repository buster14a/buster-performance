# #450: one-lane readings through the existing cold launcher

Exact-source local and native correctness passed. The initial paired/sweep
campaign and a predeclared five-round repeat of every eligible corpus unit
support manual performance acceptance: one-lane affinity calls are removed,
SQLite whole-reader medians improve, and no repeatable measurable regression
is detected by this protocol. Positive observations remain in the record;
not every individual measurement improved. Submitted-head integration CI
remains a separate delivery gate.

## Source pair and scope

| Role | Exact revision or SHA-256 |
| --- | --- |
| Baseline, including merged #449 and current checker fixes | `35f26f68d7caa9bf5f6248822100a51c06e2c878` |
| Candidate, frozen through qualification | `1d2b12c658807f466b989bcdfe2cdf548c1812d5` |
| Baseline source archive | `750688147e900e09e5b25920cbc3129a3b14bb882302d1987d6d2a37961499bf` |
| Candidate source archive | `f06f28af6609c2676b8f82125c098527d32548047a9a2dfcbfe4d5e8cbabec73` |
| Baseline native compiler | `f6f6b58ed95f7c65dc48b480fcef83f32309cd25082916ed12af4902b59f2977` |
| Candidate native compiler | `9e5b3612a4596a56d985bca03a6a5fcc7fa76ea4a4b89e470f44432dd48b4003` |

Exact main was merged once as `74a9dc49`; later unrelated revisions are
outside the pair. The source diff against that main has three files:

- `c_check_deferred.c`: one launcher choice and its explanation. One active
  lane calls existing `lane_run_cold(1, check_deferred_lane, &run, 0)`;
  multiple lanes keep `lane_run(active, ..., deferred->cpus)`.
- `c_check_corpus.c`: a test-only CPU-list input for context isolation.
- `c_check_deferred_test.c`: one additional timed/context case and its
  installed-team/affinity checks, preserving every current-main fixture.

The generic lane implementation, original refusal tests, CI selector/test
list and build flags are exactly the main versions. There is no new lane
API, field, callback, explicit noinline directive, alignment heuristic,
dependency or production language change. `lane.c` and its existing MIT/RAD
Debugger notices are retained unchanged; the new checker/test material is
original project C code.

## Why this existing utility

A one-lane cold run creates no worker. With NULL CPUs it makes no affinity
query or pin/restore call. It establishes a fresh one-lane group, resets the
single-lane counter and running state, calls the existing checker entry,
then restores Lane/taken/running. It leaves any installed team's group,
workers, CPU assignment and owner state untouched.

This is a private checker dispatch choice. Calling generic
`lane_run(1, ..., NULL)` on a pinned team would violate the existing CPU-list
contract and is still refused. Generic nested, oversized, wrong-owner,
wrong-process and mismatching-CPU dispatch validation is not relaxed. The
checker can instead isolate its known one-lane reading in the existing cold
utility while another operation is live; that private behavior is covered
explicitly by the context/continuity fixture.

Source-order equivalence and deterministic merge behavior are unchanged.
The adaptive lane rule, body ordering, `lane_index`, `lane_parts_by_cost`
and `lane_take` retain their meanings. Multiple lanes still use the fixed
team and its original affinity requirements. Timing starts at the same
point before launcher selection; `dispatch` remains call-to-first-arrival,
`wake` remains first-to-last-arrival (zero on one lane), and the whole lane
span includes the launcher. `active`, `copies`, reader-copy, walk/position
and merge accounting are not synthesized or redefined.

Earlier direct-context, helper, outlined-phase and two-get-affinity attempts
passed correctness but failed performance acceptance. Their raw evidence
and complete interpretation, including repeatable generic regressions for
the affinity trial, remain at
[`10b5cd56`](https://github.com/buster14a/buster-performance/tree/10b5cd568edc50d851fc93bfc28b9a1db9f7da8a/docs/measurements/deferred-one-lane-450-2026-10-26).
The existing cold utility avoids their extra context helper or generic
affinity-processing changes. No source-order normalization waived their
whole-reader regressions.

## Local code shape, not timing acceptance

Only exact-source checker objects were built for this diagnostic, using the
existing Clang O3/native flags without debug info. No full local compiler
build was duplicated. The compiler naturally outlines the existing cold
utility after the additional call site; no annotation is required.

| Function | Baseline -> candidate text | Baseline -> candidate stack allocation |
| --- | ---: | ---: |
| Common `check_input_run` | 0x12dce -> 0x12dee (+32 bytes) | 0x808 -> 0x808 |
| `check_deferred_lane` | 0x65fb -> 0x65fb | unchanged |
| Team wrapper `lane_run` | 0x74e -> 0x387 | 0x2380 -> 0x138 |
| Existing `lane_run_cold` | previously inlined; now 0x428 | now separate 0x2380 allocation |

Combined local lane_run/cold text grows 97 bytes. Stack allocations exclude
register pushes and alignment. Independent nm/objdump of the exact native
images confirms common text 0x12dde -> 0x12dfe (+32 bytes), frame 0x808 in both,
and callback 0x65fb in both. Native checker lane_run changes 0x761 -> 0x387,
plus cold 0x428: combined native text grows 78 bytes, rather than the local 97.
The wrapper allocation changes 0x2380 -> 0x138, with cold owning 0x2380; the
other eight lane_run copies retain their sizes. The native branch passes
count 1/NULL to the separate cold symbol. These observations do not claim
whole-binary text, instruction-count or RSS improvements.

## Correctness and reproducibility

| Gate | Status |
| --- | --- |
| Exact local O3 checker object | Passed; common frame retained |
| Focused ASan/UBSan/leak deferred suite | Passed: 56 fixtures, 891 checks, 564 merged, 6,228 bodies; zero failures/findings |
| Fresh source call graph, capture width two | Passed: 42 units, 23,931 functions, 141,897 calls, zero disallowed cycles, three allowed, zero split variables |
| Native O3 build | Passed: 42 translation units in 34.8 s, compile phase excluding link |
| Native full lane suite | Passed |
| Native deferred fixtures | Passed |
| Native all-220-program C corpus | Passed |
| Native frozen SQLite deferred/symbol comparison | Passed |
| Before/after binary/archive/input/host provenance | Passed: 226 identities unchanged within and across both cold campaigns |

The added 400-body case runs inside lane zero of a live pinned two-lane
team, on two distinct allowed CPUs. It supplies an impossible inner pin
target, leaves a take unfinished, and requires the reading to preserve its
Lane/taken/running state, installed-team pointer and immediate singleton
affinity. A second operation must use both original worker TIDs; the
caller's final affinity must also match. Insufficient distinct CPUs fails
clearly. Ordinary one-lane and eight-lane timing cases, all current-main
fixtures and scalar/vector/deferred comparisons remain enabled.

`450-cold-validation.md` retains the exact successful scratch-main
transformation, entry C file, two-hunk patch, commands, hashes and source
guards. The focused sanitizer binary SHA-256 is
`8e80e23640dfbdf4fe52202c5f4ce56fafe0adaa61cc43c77d005c9303950153`.
The earlier failed global-main-macro harness compile is retained separately;
it was corrected only in scratch, with no production change or weakened
test. Source remained frozen during every job.

## Native experiment

The coordinator alone builds, validates and measures on the 9700X using the
existing globally shared exclusive lock. Source preparation/builds and
correctness runs have separate holds; no build or unrelated test overlaps a
measurement. The existing six-CPU build affinity and explicit six-thread
wild wrapper bound descendants. The baseline was built once; later checks
reuse its verified artifact.

The measurement command retains `--passes 24 --lanes 8 --cpus
2,0,1,3,4,5,6,7`, the pinned GNU17 predefines and frozen headers/target,
`SOURCE_DATE_EPOCH=1792454400`, and the existing six permutations of
source-order, one-lane and adaptive readings. Each source runs in its own
process, preprocessing once; the 24 passes are four permutation cycles,
not independent process repetitions. No new discarded warmup or
conditioning pass is introduced. Whole-reader ns/token excludes process
startup/preprocessing and the separately reported parse.

Five alternating independent process pairs cover thirteen units:
`00001.c`, `00169.c`, `00213.c`, `00200.c`, `00182.c`, `00204.c`, SQLite,
`00066.c`, `00038.c`, `00075.c`, `00062.c`, plus affinity-trial outliers
`00056.c` and `00089.c`. Odd rounds run baseline first; even rounds reverse
the order. The full 219-program eligible corpus sweep takes one independent
pair per program with alternating build order. `00078.c` retains its known
source-order fallback, included among all 220 correctness programs but
excluded from deferred timing.

This gives 130 repeated-case and 438 sweep processes: 568 invocations,
1,136 requested-lane rows, and 464 summary rows, excluding headers. Actual
active lanes/copies remain explicit. Five bounded actual-lock groups retain
the approved sequential grouping and 55-second timeout plus one-second
cleanup allowance. All exit zero, with holds of 37/24/1/2/3 seconds.
No duplicate generic timing campaign is planned because generic source and
tests are unchanged; full native lane tests and integration CI remain gates.

Raw logs, manifests, command scripts, source/toolchain identities and full
tables belong in buster-performance. Local multicore proof uses the actual
shared cores FIFO and single-heavy-job permit: two physical cores/200%
quota/8 GiB for compile/capture; four physical cores/eight SMT CPUs/800%
quota/8 GiB for lane tests. No fixed local CPU pin or unbounded parallel
default is used.

## Initial paired results and screen

| Reading / metric | Before | After | Median of paired changes; full range |
| --- | ---: | ---: | --- |
| SQLite whole, one lane (ns/token) | 120.29 | 119.66 | -0.7211%; -0.8064%..-0.1917% |
| SQLite whole, adaptive eight (ns/token) | 104.09 | 103.84 | -0.2117%; -0.7550%..+0.1442% |
| SQLite dispatch, one lane (ns) | 7204 | 391 | About 94.6% lower build median |
| SQLite source-order control (ns/token) | 102.30 | 101.94 | -0.3714%; -1.1682%..+0.0489% |

The corresponding whole-reader build-median ratios are -0.5237% and -0.2402%.
Reconstructed from printed ns/token, whole times are 84.953249 -> 84.508319 ms
and 73.512209 -> 73.335650 ms. These exclude preprocessing and the separately
reported parse, and retain printed rounding. One-lane wakes are zero;
SQLite active/copies stay 1/1 and 8/8. Small-case dispatch is 30..40 ns.
Eight-lane SQLite dispatch rises 14718 -> 14958 ns while wake falls 19296 ->
19025 ns; no multi-lane dispatch win is claimed, nor is the entire
whole-reader improvement attributed solely to the affinity calls.

No row in the thirteen-unit set is worse in every pair. Both readings of
00182, 00204, 00056, 00169 and 00200 improve in all five pairs. Six build-median
rows are positive, notably 00066.c one lane (26 tokens), 1764.08 -> 1803.77
ns/token (+2.2499%), with mixed paired signs (-1.5993%..+3.4584%). Its
approximately +1.032 us whole-time change is retained.

The single screen has 36 rows above +2%, across 26 units: 34 rows of 9..184
tokens and both 3035-token 00056 readings (+2.5833%/+2.4269%). All actually
run one lane. The largest is 00063 adaptive (+7.6268%, 14 tokens). The full
table and every original observation remain in summary.tsv and review
notes; neither size nor normalization discards them.

## Predeclared all-corpus confirmation

Before acceptance, all 219 eligible corpus units were repeated for five full
independent process pairs, with the same 24 passes/options and alternating
build order per unit/round. No duplicate SQLite run is needed. This adds
2190 independent processes, 4380 reading rows and 438 summaries in
confirmatory/, separate from the original thirteen-unit set and single
screen. The actual shared-lock hold is 36 seconds, 17:47:42..17:48:18 UTC,
under the same 55-second timeout. All processes exit zero and 226 identities
match initial/before/after receipts.

Independent regeneration from all raw logs, using the original 4096-row
reader in two unit partitions, produces a byte-identical full summary:
SHA-256 `16fe95265dd60d197e9f13ad4b013e3db8da6b432bcbfe9a8e25ea20df4d49d7`.
The published reader changes only MAX_ROWS 4096 -> 8192 for the 4380 rows;
no grouping, parsing or statistics change. Its original cold output also
remains byte-identical.

Of 438 confirmed requested-lane rows, 33 have positive build-median ratios,
34 have positive paired medians, and none is positive in all five pairs.
No build-median ratio exceeds +2%. Adverse cases remain explicit:

| Observation | Before -> after ns/token | Build-median ratio | Median paired change; range |
| --- | ---: | ---: | --- |
| Maximum ratio: 00107 one lane, 24 tokens | 1854.75 -> 1883.96 | +1.5749% | +0.9176%; -3.2546%..+3.5645% |
| Maximum paired median: 00151 adaptive, 90 tokens | 575.98 -> 578.08 | +0.3646% | +2.8326%; -4.7676%..+5.5357% |
| Original concern: 00066 one lane, 26 tokens | 1738.62 -> 1753.69 | +0.8668% | -0.4233%; -5.1190%..+0.9562% |

The only positive ratios on inputs of at least 1000 tokens are 00220 adaptive
(5048 tokens, +0.1857%), 00193 one lane (3055, +0.0581%), and 00125 adaptive
(2997, +0.0235%); all paired medians are negative with mixed ranges.
00056 improves again in every pair (-1.0144%/-1.1398% build medians), while
the largest original 00063/00033/00067 outliers have lower confirming build
medians. Original adverse samples remain, without post-hoc pooling or a
source-order-normalization waiver.

Manual acceptance passes for this exact pair and protocol: substantial
unnecessary dispatch work is removed, correctness is preserved, and the
complete repeated corpus detects no repeatable measurable regression.
Five process pairs are not a manufactured confidence interval or proof of
zero effect. The cold record contains 2758 timed processes in six bounded
holds, all successful, plus separate preparation/acceptance.

Instruction counts and whole-process RSS are not outputs of this checker
timing harness. Exact submitted-head integration CI remains a separate gate.
The tracked guide records these results with an immutable evidence link.
Arena/costliest-part follow-ups remain separate. No automatic merge is authorized.
