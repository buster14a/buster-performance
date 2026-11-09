# Three-case multicore record, 2026-11-08

This records the completed compiler `2dc50258e8b33393474b64032a5cbe9f17c63def` campaign with reviewed performance tools `21df57f8d3da84fa2ea94512f2674facdaa1547c` on the Ryzen 7 9700X. All three timing cases and 24 separate wait observations passed independent record-integrity review. This does not qualify later compiler revisions, decide parent-issue acceptance or authorize a merge.

This dated directory is append-only. The original Astra material, harness, diagnostics, historical records and Git history remain unchanged. The failed 6 November attempt contributes no samples to these fresh cases.

## Primary curves and separate control

Each case contains 82 separately guarded compiler processes: one reference, nine warmups, 63 normal samples (seven repetitions at nine slots) and nine separate stage-report processes. The primary startup affinity mask stays `0..7` for every N; the driver pins its N session lanes to the prefix `0..N-1` with worker budget 8. The x-axis is requested session lanes, not measured utilization of all compiler threads or helpers. The ninth slot is a separately labeled one-lane CPU2 control with startup mask `4`; it is not another primary point. These are warm-input, compile-only `-c`, fork-to-reap times including object output and process startup/exit. Source/input hashing and output comparisons are outside that timed interval.

| Lanes | SQLite median ms | Synthetic median ms | Musl median ms |
|---:|---:|---:|---:|
| 1 | 139.785250 | 1743.085178 | 978.339708 |
| 2 | 135.792805 | 940.667486 | 523.557457 |
| 3 | 134.695636 | 686.198261 | 368.714396 |
| 4 | 133.272160 | 569.357645 | 291.008920 |
| 5 | 131.493784 | 511.578836 | 247.306256 |
| 6 | 131.763373 | 494.410153 | 221.682130 |
| 7 | 131.696400 | 473.469655 | 204.813447 |
| 8 | 131.518821 | 455.670231 | 191.741044 |

| Workload | Primary 1-to-8 speedup | 8-lane min–max ms | Separate CPU2 median ms |
|---|---:|---:|---:|
| SQLite | 1.062853582× | 131.077885–136.138982 | 140.329778 |
| Synthetic | 3.825321602× | 453.392244–456.681714 | 1733.744808 |
| Musl | 5.102401070× | 191.206693–192.635717 | 975.019221 |

The archived `summary.tsv` files retain every lane count's min/median/max, effective serial fraction and model fields. Raw records retain each repetition, resource counters, stage output, identities, placement, status and object hashes. The one-lane denominators above come from the corresponding primary mask, not from the CPU2 control.

The recorded policy is mixed: CPU2 used performance governor/performance EPP; the other selected cores used powersave/balance_performance. The prefix first includes CPU2 at three lanes. These are not uniform-policy or frequency-normalized curves. Policy snapshots do not establish continuous utilization, residency or actual frequency. CPU2's `siblings=2` means the CPU list `{2}`, not two hardware threads.

## Serial-stage bounds

| Workload | Instrumented one-lane serial-stage lower fraction | 8-lane Amdahl-model upper bound | Infinite-lane model bound |
|---|---:|---:|---:|
| SQLite | 0.872145977 | 1.125964167 | 1.146597044 |
| Synthetic | 0.000489567 | 7.972677908 | 2042.623395785 |
| Musl | 0.001807747 | 7.900031173 | 553.174624648 |

The fractions divide the conservative serial-stage sum by its paired instrumented one-lane whole-process time. Single-unit SQLite includes the documented ordered stages and `lower.prepare` once; the multi-unit cases identify only global `setup + release` outside their units phase. They are lower bounds from stage reports, not an unperturbed serial fraction or proof that the remaining work is perfectly parallel. The model `1 / (s + (1-s)/N)` assumes unchanged work and execution cost; frequency, caches, scheduling, memory contention and overhead can change those costs. The effective fraction fitted from normal-sample speedup remains separately recorded and includes machine effects.

## Independent timing review

Each case passed the final independent C reader, a positive copied fixture and thirteen deliberate corruptions requiring exact exit 1 and the intended diagnostic. The original records were hashed before review, after review and after copied-fixture controls:

| Case | Original files, including reference objects | Outputs per sample | Immutable original manifest SHA-256 |
|---|---:|---:|---|
| SQLite | 1500 | 1 | `4bfaeee165f677f979fea2a0296b890ddda8a1f4ba609ea5870e033905365fd8` |
| Synthetic | 2011 | 512 | `99375315b1b389d07d0f8ac2c5101d6ca5a97ac76ae8dabe832416c5e8463e7f` |
| Musl | 2808 | 1309 | `652aeb3831494e0df06e64e8d6d98ae075caeb4a6fa4d95e83f9ad0b836c9e73` |

The review checked 246 records, 4602 input-manifest entries, all 789 overlapping input paths, 1822 retained regular nonempty reference objects, 149404 object-digest entries, exact arguments and lane/CPU receipts, every guard/status, stable policy/environment/identities, raw stages and recomputed summaries. Shared compiler, source, runner, lock, input and environment identities agree. The final timing reader source is `83c5a3f53041b6303f409068003bf6edde908d8cdb8b7fd85b1dc16bdf3c3ea4`; the unchanged mutator is `9b13ba3a372da3259a03bd2c0d7d041bf808c5012660cbb2ee7555292a2dac89`.

Compact negative-control evidence retains exact text snapshots from the completed immutable copied fixtures, with per-target before/after hashes: 36 changed timing targets (12 per case, including three stage-header controls per case) and 12 changed wait traces. Three additional timing controls create an empty extra-record directory; one wait control changes only the expected-owner PID argument while its trace stays identical. Their operation/argument records are included separately. No object bytes were mutated: the timing object-hash control changes the first ASCII hexadecimal byte of `warmup-0/objects.sha256`. These snapshots document the existing 52 controls without rerunning them and add no accepted measurement samples; timing/wait totals remain 246 and 24.

Successful non-reference objects were deleted by the reviewed collector only after complete-byte comparison. Their hash receipts remain, but independent review cannot repeat comparisons of those deleted objects. The 1822 reference objects remain on the host through final review; all object files are omitted from this public package.

## Separate perturbed wait observations

After all three timing cases and cross-case checks were accepted for record integrity, root admitted exactly 24 ordinary observations: each case at lane counts one through eight. Every observation acquired its own shared-lock grant and guard, checked its complete qualified timing reference, ran the separately instrumented compiler and required fresh output byte equality. The earlier four-lane `--smoke` is retained separately and never counted among these 24.

Independent review passed all 24 observations, 108 per-observation lane/pin/calibration sets, 2160 metric rows, 14576 diagnostic object-digest entries, every raw PID/status/argument/placement/stage/identity/policy/guard record, a positive copied eight-lane trace and thirteen targeted corruptions. The 108 sets are a sum across separate processes, not a 108-thread run. The 827-file ordinary-wait manifest stayed identical before review, after review and after controls: `3b5637689dc6bbc6e6081e0c3eb942e2197044a83ff7c48827226c38523a570d`. All three accepted timing manifests were rechecked unchanged. The final wait-reader source is `286f166904c0f6a8618810e1bfb8198163219a90545bc0962ed8e4c5a89f36f5`.

The maximum observed active guard was 2,274,126,741 ns; the maximum queue-inclusive wrapper was 192,038,838,068 ns. Every successful record has child wall time no greater than guard time, guard time no greater than wrapper time, guard at most 255 seconds, zero status, no interruption and clean descendants. The configured wrapper timeout is 1200 seconds including queue wait, not a measured lock hold. Failed or interrupted wrappers do not supply valid lock-hold upper bounds; kernel-uninterruptible tasks remain the existing guard limitation.

These aggregate histogram values are interval counts, not counts of distinct waiting sessions. They cannot be added as process wall time. All fifteen unlisted class/outcome vectors are zero. A separate text recount corroborated every vector.

| Class / outcome | <1 us | 1–10 us | 10–100 us | 0.1–1 ms | 1–10 ms | 10–100 ms | 0.1–1 s | >=1 s |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Initial spin / completed | 12 | 86 | 0 | 0 | 0 | 0 | 0 | 0 |
| MWAITX / completed | 27 | 1102 | 68 | 10 | 17 | 0 | 0 | 0 |
| Barrier futex / completed | 0 | 0 | 18 | 1 | 3 | 0 | 0 | 0 |
| Other futex / completed | 0 | 8 | 69 | 155 | 56 | 0 | 28 | 0 |
| Other futex / EAGAIN | 1 | 19 | 0 | 0 | 0 | 0 | 0 | 0 |

Finite bins include the lower boundary and exclude the upper. The 1–10 ms bin straddles 1.5 ms and cannot establish an exact count above it. MWAITX's `completed` label is synthetic instrumentation classification, not a wake reason. Clock/loop overhead, scheduling and interrupts are included. Only session lanes through forced join are covered; non-session threads and later terminal parking are excluded. Worker TIDs are positive and unique but not independently corroborated. No C-state residency, wake-reason or frequency inference follows.

## Pins and prior correctness

| Identity | SHA-256 / revision |
|---|---|
| Compiler commit / tree | `2dc50258e8b33393474b64032a5cbe9f17c63def` / `1829aa50f677d713bcb250966746575d526989ef` |
| Control compiler | `51b54dd02986a28f294c0d5b2539e93739acb8962851127316da7953d4f8b09b` |
| Instrumented compiler | `098eebdffc96491035b3508d56df6546aba5c97209b3f556088f9b1b73d049e3` |
| Applied diagnostic diff | `199e7888f51df9f46995ea751198a00f92ba306acd3272b016068ed66a245414` |
| Timing runner | `e354444a18ae4a079014d3d0bef0b5107d8294ca633cbc2655f70ed04d416ca1` |
| Wait launcher | `c6389cb7c8529f0a09b573de59b328e7e19c48c1c664bce3dd364c45c3eb5a6f` |
| Wait validator | `91168e21edbe8c68e56eb491ec41a2a98e241fe00b529ee641366c7ae99fce17` |
| Reviewed tools commit | `21df57f8d3da84fa2ea94512f2674facdaa1547c` |

The timing executable is the retained, previously qualified Release `znver5`, debug-info-zero compiler. No new compiler build was substituted for this campaign. Its [exact-merged native qualification](../merged-native-qualification-2026-11-06/README.md) passed all 126 inventory sections with its documented internal feature/oracle exclusions. The [exact main-push sanitizer/fuzz run](https://github.com/buster14a/buster/actions/runs/42256447354) passed; its skipped hardware jobs are distinct from that native qualification. The six hosted checks at the reviewed tools head passed (four harness/prepared-driver/validator jobs plus CodeQL and Actions analysis). These remain scoped receipts, not qualification of a later compiler.

The timing runner was copied unchanged from its separately built `440012ed` executable; its runner/test sources are byte-identical at the reviewed tools head. The wait launcher was built separately with pinned Clang 23.1.4; the **Clang executable** SHA-256 is `c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67`. The launcher's own executable hash is the distinct `c638...` value in the pin table. Input manifests cover SQLite 3.53.2, the exact seed-149 512-file × 200-function generator output and all 1309 selected musl C objects. Header/predefine/toolchain/generator receipts and the diagnostic applicator's exact reviewed pins are retained or linked from the original preparation records; no corpus source is imported here.

## Archives, verification and public derivatives

This package adds compressed record archives rather than thousands of duplicate receipt files to the textual diff:

- `timing-records.tar.gz`: three closed timing cases, commands, summaries, provenance and preparation receipts.
- `wait-records.tar.gz`: the separate smoke, 24 ordinary observations, actual admission, reviewed command list/controller and launcher build receipts.
- `independent-audits.tar.gz`: timing/wait audit reports, immutable original manifests, exact original/final helper sources and drivers, positive and rejection-control receipts, compact changed-target text/patches with before/after hashes, cross-case bindings and publication recipe/mappings.
- `failures-and-history.tar.gz`: initial operator audit failure, original/corrected reader failure history, the excluded interrupted 6 November attempt and unsuccessful publication preparation history.

Each archive has a relative member inventory, internal `SHA256SUMS` and per-file original/public derivative mapping. The outer `SHA256SUMS` covers the complete package. `record_review.c`, `wait_record_review.c` and `record_mutate.c` are separate byte-exact copies of the final reviewed timing reader, wait reader and mutator; none was combined or changed for publication.

Public copies omit only explicitly identified unrelated shared-lock waiting-holder command/title/link metadata according to the included reviewed recipe. Own grants, essential identities, all metric/status values and failures are retained. The recipe and per-file mapping distinguish immutable original SHA-256 values from the public derivative SHA-256 values; a public internal checksum cannot validate an embedded original hash. Original raw files and their accepted full manifests remain unchanged in the isolated host and audit workspaces.

The strict sanitizer accepts only an immediate waiting-holder/title/link block, with at most an immediate optional pull-request line; all other bytes remain exact. It remains unchanged after correctly refusing incomplete notices. A separate fixed allowlist covers exactly 72 independently inspected metadata-only files: three one-line notices, 62 notice/title files and seven multiline other-holder command fragments. Each whole-file omission is bound to its exact path, original SHA-256, byte length, line count and final LF. The allowlist accounts for 32,499 original metadata bytes and 301 lines. Its marker transformation is labeled separately from strict complete-block removal; it is not a general incomplete-block parsing rule. The actual recipe, catalogs, allowlist, source review and per-file derivative ledgers are in `independent-audits.tar.gz`.

Run `sh review.sh` to verify package hashes, safe archive membership and each extracted public manifest. This checks the publication package only. Exact native reader replay also needs the retained original directory layout, pinned tools/binaries, frozen external inputs and omitted reference objects. Sanitized copies alone cannot replay the full native audits or repeat the collectors' deleted-candidate byte comparisons. The original precise invocation/build drivers and manifests are included for that separate retained-original replay; no new compiler campaign runs from `review.sh`.

Executables, object files, external corpus/source/header archives, build trees, caches and full duplicated mutation trees are excluded. Failed input/reader attempts are not silently replaced by later passes.

## Failure history and disposition

The 6 November controller stopped while SQLite warmup 3 was queued; it exited 1 and recorded an incomplete failed case. Its reference and warmups 0–2 were partial preparation only; no timed repetitions, synthetic or musl case ran. Those records remain separate and unused.

The initial fresh operator audit mistakenly applied the compiler's no-sparse-index rule to the intentionally sparse performance checkout and stopped before binary/input hashing. Its original log is retained; the corrected audit passed. The initial independent timing reader rejected the legitimate `time-stage` header's `ms` label as a number. Its source and failure are retained; reviewed v4 recognizes the exact header and adds three header-rejection controls without relaxing any identity, numeric, count, guard or policy check.

The first publication-sanitizer candidate was rejected in source review before build/use because an incomplete holder block could consume later own records. Its exact source, review finding and corrected candidate/fixtures are retained. No raw record was changed. Final publication-package verification and independent review are separate from the native record qualification above.

The first public-copy preparation then stopped with status 1 on an incomplete two-line queue notice, as the strict corrected sanitizer required. Its first refusal, exact recipe/status and nonpublishable scratch-tree manifest are retained. The scratch payload remains private, unused and unaccepted; the final archives are prepared from a fresh derivative tree after review of the exact 72 exceptions above. No additional compiler measurement was needed for packaging.

Independent completeness review of the first frozen package found that planned changed negative-control target texts had been omitted, although their source, commands and results were present. That package remains privately preserved and was never published. This final preparation adds the compact completed-fixture target evidence above and retains the original package bindings and review history; it does not rerun native work or reduce the publication plan.

Earlier historical sanitizer/fixture failures and internal qualification exclusions remain documented in the preserved original material. This record supplies pinned evidence; parent-issue acceptance, readiness and merge decisions remain separate.

Original report/helpers follow the project's retained Apache-2.0 WITH LLVM-exception terms. No third-party implementation, corpus or source archive is imported.

---
Agent session: `01a1b81e-6ae2-7022-84e9-95739850f990` (Codex session ID; no private session URL is exposed). Tasks: `/root/ownership_audit`, `/root/identity_validation`, `/root/ownership_audit/package_report`.
Model: OpenAI / GPT-6 (exact runtime variant not exposed).
