# Integer builtin scratch reuse (#665), 2026-10-28

**Assessment: retain the bounded scratch/frame fix and its large generated-input
compile improvements. Ordinary SQLite throughput remains unresolved within the
matched A/A variation.** This record qualifies the exact frozen comparison below;
it establishes no current-main, corpus-wide or additive speedup.

- Baseline: [`241fcb3e`](https://github.com/buster14a/buster/commit/241fcb3e9a5a55d8ccc3dfffc7d9d0efd56bdda7).
- Candidate: [`a207fcd7`](https://github.com/buster14a/buster/commit/a207fcd7e742c517f0d5bac6ff1bd5ac2772c360), retained as the plain
  `codex/665-frozen-native-candidate` source ref.
- Source draft [#714](https://github.com/buster14a/buster/pull/714) instead ports
  only this slice onto pinned main `12db4a0e`, including #678, at
  `25783a29a42e0bafebd5e09a6b934ff02f4c0607`. Its correctness/frame checks are
  separate below. The frozen performance pair contains neither #688's
  register-home change nor the other retained performance changes.

The historical 65,536-local refusal was already removed before this baseline:
its actual limit is 16,777,216 and it compiles the 8,000-call input. This slice
reuses integer recipe scratch and argument slots; it does not claim to have
removed that old refusal or to reuse ordinary source variables.

## Frozen native results

Ryzen 7 9700X, Clang 23.1.1, usual release `build.sh` flags with
`BUSTER_DEBUG_INFO=0`. Each compiler was built from its exact git archive with a
`SOURCE_COMMIT` receipt. Native compiler SHA256:

| Role | SHA256 |
| --- | --- |
| 241 baseline | `6e7cfbe2e4573ab4c001c7dc9b8b13bbb3a09c2b4f2c9c6a88f03f67daa9027f` |
| a207 candidate | `213dbb6edb6313b6f6d5b883497dda3c68d165fc63c8bfae3510d3c62068bd80` |

These are process wall medians in milliseconds, 12 timed samples per role.
The scaling rows include the stage clock; independent fresh-copy confirmations
omit it. Percent changes compare candidate with baseline; negative means less
time. Every run includes input preparation, pool setup, lowering, backend and
output writing.

| Generated one-function input | Baseline | Candidate | Change |
| --- | ---: | ---: | ---: |
| add-overflow ×2,000 | 37.823 | 10.680 | -71.76% |
| add-overflow ×4,000 | 127.006 | 19.567 | -84.59% |
| add-overflow ×8,000 | 466.376 | 36.940 | -92.08% |
| popcount ×2,000 | 11.350 | 7.754 | -31.68% |
| popcount ×4,000 | 26.906 | 13.075 | -51.40% |
| popcount ×8,000 | 79.427 | 24.427 | -69.25% |
| add-overflow ×8,000, fresh copies/plain | 466.810 | 36.717 | -92.13% |
| popcount ×4,000, fresh copies/plain | 27.403 | 13.097 | -52.21% |

At 8,000 overflow calls, the stage clock charges Tier 0 433.012 → 3.785 ms;
lowering itself is slightly slower, 6.452 → 6.524 ms (+1.1%, retained).
Backend setup, lowering and emitted-function work together take
440.964 → 11.667 ms. For popcount ×4,000 those totals are
18.964 → 5.328 ms, with lowering 2.743 → 2.633 ms and Tier 0
15.280 → 1.820 ms. The saving is concentrated in Tier 0 after reducing the
local set, including its known full-ordering cost and changed register/spill
choices. No hardware-counter or call-site profile apportions those effects
further. No core/UMC/energy claim is made.

The 8,000-overflow peak RSS is 197,626 → 194,566 KiB; popcount ×4,000 is
91,438 → 91,328 KiB. Full raw phase/resource rows are retained.

### Small and ordinary controls

The small cases have 64 timed samples per role; SQLite has 12. A/A uses two
fresh copies of the exact baseline executable. No tiny-input or SQLite gain
is claimed from these limited placement controls.

| Plain whole-process control | Role0 ms | Role1 ms | Change |
| --- | ---: | ---: | ---: |
| one popcount, base/candidate | 1.357216 | 1.352247 | -0.366% |
| one overflow, base/candidate | 1.363794 | 1.359100 | -0.344% |
| one popcount, baseline A/A | 1.338456 | 1.338500 | +0.003% |
| SQLite, base/candidate | 129.687562 | 129.898371 | +0.163% |
| SQLite, independent fresh copies | 130.153108 | 129.927826 | -0.173% |
| SQLite, baseline A/A | 129.924740 | 129.714652 | -0.162% |

The instrumented SQLite cohort is +0.188% wall, with lower/backend total
22.5265 → 22.4805 ms. Opposite-signed plain repeats comparable to A/A do not
resolve an ordinary-input throughput effect. In these bounded controls no
material small/SQLite regression was established; this is not a general
neutrality guarantee or a cross-placement study. The frozen SQLite baseline,
candidate and independently verified scalar object are byte-identical at
`dfbed07cd778774a1bff0e431a74ff406adc2029d501d1720b63b6bca6068eda`.

## Correctness and generated frames

- Native frozen checker: 465,859 checks, zero failures, Clang 23.1.1.
- Native source matrix: 30 generated inputs (add/sub/mul/popcount/wide at
  1, 64, 1,000, 2,000, 4,000 and 8,000 calls), each compiled by Clang -O0,
  baseline, candidate and scalar candidate. All 120 executables run 143
  complete boundary/LCG inputs; all 90 Buster outputs match Clang, and all
  30 candidate scalar/vector object pairs match.
- A nine-body input with 4,096 multiply-overflow plus 4,096 popcount calls
  passes Clang runtime comparison and identical single/eight-lane/scalar
  candidate object checks. The lane stage confirms the function-lane path ran.
- Local integer lowering suite: 970,287/0; focused ASan/UBSan scratch API:
  216/0. Source fixtures cover repeated unary/overflow/product recipes,
  nested destination expressions, same-class operands, wide signedness,
  noncontiguous pool growth, lifetime resets and transactional refusals.
- On local Clang 23.1.4, frozen a207's full checker has four familiar
  `fpclassify` selector-order oracle differences. Exact pure241 control has
  the same four case names and values. Their negative receipts are retained;
  they are not called a full local checker pass.

Native prologue reservations, excluding pushed registers and the red zone:

| Control | Baseline | Candidate | Clang -O0 |
| --- | ---: | ---: | ---: |
| 8,000 overflow blocks with ordinary `int r` objects | 831,912 B | 64,008 B | 31,880 B |
| 4,000 popcount accumulations | 127,920 B | 0 B | 0 B |

Both Buster overflow builds push 48 B; Clang pushes 8 B. Pooled popcount
pushes none. The remaining overflow frame is principally its 8,000 ordinary
source result objects at eight bytes each, about twice Clang's reservation.
No general source-local lifetime pooling is introduced.

### Publication head and CI

The distinct source publication head `25783a29`, locally built with Clang
23.1.4 on a Ryzen 9 7940HS, passes all 41 release units, integer lowering
970,287/0, full checker 465,960/0 and driver 21,648/0. Generic scalar-host
focused source fixtures pass ASan/UBSan 89/0; scalar syntax and actual two-lane
lifetime/object checks pass. Its two large frame/runtime controls were replayed
independently, reproducing 64,008 B and zero reservations and 143-input Clang
agreement. These do not transfer the frozen pair's timing to that head.

The coordinator observed all required #714 gates green at 17:30:59 UTC on
unchanged head `25783a29`: native job 122978237767, portable 122978239439,
Benchpress 122984089214, aggregate 122985013423, changes and storage policy.
Two earlier native VM eligibility failures occurred before compiler build or
tests; they were retained and only failed jobs were retried. The successful
eligible run cleared the unmodified gates. See [source PR checks](https://github.com/buster14a/buster/pull/714/checks).

## Method, audit and limits

Every target extraction/build/test/cohort/capture/package/download uses the
shared exclusive lock. Settings were not changed. Each timing hold contains
one homogeneous input/configuration and pins its lean C supervisor/children to
CPU 2 with `--lanes 1`. Equal-length fresh executable and output paths are used.
Full-size primers run roles 0,1,0, followed by ABBA cycles. Every ordered
predecessor/role pair is equally represented in each cohort. A/A/copy controls
are explicit, not inferred from rotating a mixed corpus.

The independent reader requires the declared cycle count, exact rows/order/
predecessors, finite metrics, successful child statuses, output presence and
complete stage reports. No sample or major fault was discarded. Fifteen
cohorts contain 672 timed and 45 warm samples (717 total); all statuses and
major-fault counts are zero. The final byte audit checks every one of the
717 objects within its input/role, plus A/A equality. The 843-object SHA256
manifest also covers 120 native matrix objects, five lane controls and the
verified scalar SQLite object. Bulk objects/executables are omitted from the
archive, with their hashes and audit source/receipts retained.

The phase table's lower/backend total sums backend setup, lowering, Tier 0,
emit setup, branch sizing, encoding, unwind, code atoms and debug. Plain
cohorts' zero phase columns mean unmeasured, not zero stage cost. Stage and
plain repeats are separate observations, not a paired estimate of clock
overhead. Local correctness-harness wall times are uncontrolled and are not
performance qualification.

Independent read-only reviews covered the production lifetimes/rollback,
publication port and measurement helpers. Before target timing, the helpers
were tightened to require exact requested cycles and all 143 complete runtime
rows/read-error checks. Truncated/whole-cycle-deleted receipts and empty/
truncated runtime output are rejected. Initial unsupported seed options,
adapter cleanup-name and warning-order preparation failures remain under
`local/`; no timed dataset was replaced or trimmed.

The stress gains are far larger than the observed bounded A/A/copy variation;
no broad placement matrix was run. No current-main/general/additive claim,
codegen-runtime-speed claim or hardware-counter attribution follows. The input
mechanism, source/toolchain, code bytes and all costs are explicit for review.

## Artifacts

- `native/evidence-a207.tar.gz`: complete lean target record, **453,048 B**,
  SHA256 `bc33f7c649d7ad982c3cfaf2b714f8ff488bcb8c2ff7bcba0df3d012ab76fe56`.
  Packaging held the target lock, 17:34:56–17:34:58 UTC, after all timings.
- The full 717 warm/timed object payloads, 120 matrix objects, five lane objects
  and scalar SQLite object were kept on the target under `665-a207/results`,
  `qa`, `qa-many` and `qa-sqlite-scalar.o` at packaging. Those native payloads
  were **not downloaded or published**. The downloaded/public archive contains
  their hashes, byte-audit receipts, source inputs and text logs, not object or
  executable payloads. Independent local correctness objects remain private
  outside this record; the local archive also excludes objects/executables.
- `native/all-stats.txt`, manifests, host/toolchain and raw command logs are
  also directly browseable. The archive includes every cohort row/log, original
  cases, method versions, QA outputs/frames and compile-command receipts.
- `method/` exposes the original C helpers for review; `REPRODUCE.md` gives
  commands. SQLite and system headers are external inputs, not copied here.
- `local/` retains original failures, sanitizer/build receipts and the bounded
  local correctness archive; `publication/` keeps the separate head's receipts.

All helpers/cases are original project material under Apache-2.0 WITH
LLVM-exception. No external implementation is incorporated. This evidence
repository commit makes no human DCO certification; compiler certification was
scoped to the compiler repository only.
