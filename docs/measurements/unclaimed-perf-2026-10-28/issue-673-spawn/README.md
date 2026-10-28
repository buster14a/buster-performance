# Issue 673 clean-launch qualification

Source is original Buster C on `codex/perf-673-spawn`, commit `1d076d67`, based on
the complete worker-budget candidate `b7681dcf` and baseline `bc1b4861`.
No PR, push, GitHub comment or host setting change is part of this work.

The source captures GNU make authentication at command entry, borrows only
available bytes after the existing work rule, and returns each exact byte after
the worker join. An explicit `--worker-budget=N` includes the caller. The new
guardian uses `posix_spawn` and immediate dispatch into a clean address space;
no token is reserved during parsing. Signal-group termination, stale/reused
authentication descriptors and reusable-command cleanup remain covered.

`protocol-no-gnu.txt` and `protocol-asan-final.txt` each report 186 checks and
zero failures. The named-parent-mapping oracle verifies that a live guardian
retains no parent mapping; parent CLOEXEC flags remain set. `final-lane-tests.txt`
reports 2,720 checks and zero failures. `callgraph.txt` reports 41 units,
25,137 functions, no disallowed cycles and no split variables. The five
`make-*.txt` cases each contain 32 ownership events; the independent sweep
checks maximum ownership 4 under real GNU make 4.4.1 `-j4` and verifies the
closed-descriptor fallback's one-worker grants.

The local two-core same-head prototype screen (`spare-token.txt`, before the
additional mapping/CLOEXEC regression was compiled) records
11 rotated measured pairs, after two warm-ups per role. Cooperative forced-two
median is 175.845 ms, versus 175.239 ms with `env -u MAKEFLAGS`; ranges overlap.
Minor faults are 3,445 for both. All 26 outputs have SHA256
`427dd0a495f26927a22c71c3b2fb19996f9751d5d704ef7a55d4858172b9ef65`, and all
worker receipts grant and activate two workers. This local screen establishes
neither general neutrality nor target speedup.

The superseded fork guardian's target negative control is retained in
`../evidence-673/target/frozen-b768/`. Its identical-affinity forced-eight
cooperative case is 136.027 ms versus 134.312 ms without jobserver authentication
(+1.28%), with 6,459 versus 4,910 minor faults. Each role has 13 fresh process
repetitions (11 measured, two warm-ups), grant/active eight, and identical
objects. Never attribute these negative results to the clean-launch source.

Target native clean-launch binary SHA256:
`c1ff5c08fff9b360ccc4caa77fed24fc0c073549278402030b72e2b9edb4d72d`.
Native baseline is `d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d`.
SQLite source and pinned-predefines identities match the frozen campaign.
Native protocol passes 186 checks, native lane/emission coverage passes 2,768,
and all five real GNU make cases preserve maximum ownership 4 of 4. A real
`make -n` plus recipe opens no missing source and creates no output (strace
retained). The native same-head spare-token pair is 134.221 ms cooperative
versus 134.277 ms without jobserver authentication; ranges overlap and minor
faults are 4,912 versus 4,910. All 26 outputs are identical, each using eight
workers. Raw results are collected under `../evidence-673/target/clean-spawn-1d/`.

The exploratory real GNU make `-j8` policy screen uses CPUs 0–7, eleven rotated measured
repetitions and two warm-ups for each policy/workload. Every policy uses the
same original C resource wrappers and actual make jobserver. `free8` removes
MAKEFLAGS for the compiler only; `cap1` sets its explicit cap to one; the
cooperative policy has cap eight and owns each extra lane through make.

| Eight-file workload | Jobserver (ms) | Cap one (ms) | Free eight (ms) |
| --- | ---: | ---: | ---: |
| Eight SQLite units | 409.450 | 409.106 | 425.413 |
| Eight tiny units | 10.032 | 9.450 | 9.675 |
| Two SQLite and six tiny | 180.583 | 178.846 | 173.831 |

This mixed-list screen is fenced for predecessor-workload confounding: simple
slot rotation often places a lighter uneven workload before the large
cooperative cohort. Its apparent large-cohort wall reduction is 3.75%; use
the separately balanced controls for any acceptance decision.
Tiny and uneven ranges overlap; their medians show tradeoffs rather than a
general neutrality or scaling result. Major-fault medians of 3–7 are retained.
This is one placement, not a multi-placement acceptance claim. All 99 measured
processes and all 18 warm-ups exit zero. The 936 output digests contain exactly
390 SQLite objects (`cb578161715c2ecf83659069957077739447d8eccb7be54953faeb30990d9755`)
and 546 tiny objects (`80d4c323efc3c80bba94dd853dd6ad0bdbaab088e44214b352bec86ecd3c52de`).

The replacement `policy_balanced.c` runs each workload as one locked group,
with a full-size primer and four repetitions of a nine-edge cyclic role
sequence. Every predecessor/current pair occurs four times, giving twelve
measured cohorts for each of jobserver, cap one and free eight. Outputs,
resources, perf counters and exact commands are retained for every case.
The independent `policy_stats.c` reader checks actual logged order, all pair
counts, case uniqueness, zero status, output comparisons and full counter
coverage. It uses even-sample medians and retains all major faults.

`matrix.c` runs every sample through its own shared host lock, pins all shared
cohorts to physical CPUs 0–7, and sweeps external jobs 1/2/4/8 over baseline/head
one/default/eight workers, head explicit cap one, and a real GNU make jobserver
with total cap equal to its `-j` value. Pinned-one rows are separate placement
controls. Every cohort saves all process receipts, wait4 resource records,
perf task-clock/context-switches/migrations/cycles/instructions/faults, exact
arguments and byte comparisons against the first reference object. These
controls do not infer oversubscription from the old unmatched-affinity result.
Real make recipes also save original-C `wait4` resource records for each
compiler; the same wrapper is used for every make policy. The target has no
GNU time executable. The resource wrapper was finalized before any make row
executed; the already completed direct file cohorts use their own `wait4`
collector. No completed sample was discarded or changed.
