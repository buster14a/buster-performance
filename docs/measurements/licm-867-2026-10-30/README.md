# LICM adaptive completion qualification, 2026-10-30

At the exact [Buster #915](https://github.com/buster14a/buster/pull/915) candidate, the long-chain whole LICM pass takes 65.3% less time than its pinned baseline across 12 matched process/placement pairs on the locked Ryzen 7 9700X. The paired candidate/baseline median is 0.3470, range 0.3362–0.3551, with exact checked results. This follows the unanswered qualification review for [#867](https://github.com/buster14a/buster/issues/867).

The measurement includes the complete public LICM call: verification, analysis, allocation and rewrite. It makes no end-to-end compiler-throughput or emitted-program-quality claim.

## Revisions and machine

- Baseline: `434eb27646fa189662e5ada0e61a41f54ba70c4f`.
- Candidate: `945a86fb168724c460b9adc3296c3eae7f6877ae`.
- Source archives came from `git archive` of those exact commits. SHA-256: baseline `24a60818f69d419598d8b6398b1129603cb9d44a8b3a624058ef7167afa13faa`; candidate `1667d38ede047d90bbb1659a4ef1aa748f1d12c24385613830f1ed147ad4b0d9`.
- Those transfer archives and executable images are not added to this repository. Their recorded source pins, build commands and SHA-256 identities support reproduction; the measured binaries remain in the campaign directory on the host.
- AMD Ryzen 7 9700X, CPU 2. Every build and measurement used the existing `/var/lib/buster-9700x/lock` through `~/buster-fast-bench/exclusive.sh`; lock holds covered individual builds or individual benchmark processes. Other sessions and CI could run between processes.
- Official LLVM/Clang 23.1.4, release commit `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, compiler SHA-256 `c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67`. LLVM license SHA-256 `8d85c1057d742e597985c7d4e6320b015a9139385cff4cbae06ffc0ebe89afee`. The shared setup uses the existing approved `tools/ci/setup-benchpress.sh` cache and verified official archive digest.
- `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh shifts ... main_unit_backend.c 0 64 128 192`, with the source build's normal `-O3`, `-fwrapv`, `-funsigned-char`, `-fno-strict-aliasing`, `-Wall -Werror` and fixed-address link. Full commands and binary hashes are retained in `raw/`.

## Campaign

The unmodified source builds run `benchmark-ir-optimize-passes --pass licm --instructions N --samples 21` for requested chain lengths 4096, 255 and 17. Each invocation also checks and measures the existing no-loop and nested-loop controls. There are three independent processes for each of four placements, with baseline/candidate order rotated by process and placement. The benchmark alternates scalar/vector sample order internally and checks exact output plus interpreted behavior before timing.

At length 4096, another three independent processes per placement run `--only vector`. Placements 0 and 128 additionally run `--only vector --after-scalar 200` once each per variant, with the scalar twin conditioning every vector sample. Thus the primary campaign contains 100 successful benchmark processes and 516 timed shape/path summaries.

Placements shift the backend object's ordinary `.text`. `scripts/check-placements.sh` rejects a missing LICM/worklist/timing symbol, a function-size change within a variant, or movement other than exactly the requested 0/64/128/192 bytes. This is code-placement sensitivity, not additional hardware diversity.

The evidence-only `source-adapter.patch` prepares each C fixture through the normal source checker, both typed-to-IR lowerings and SSA promotion outside timing. It retains the promoted function in the input arena, checks exact scalar/vector LICM output, requires successful interpreter execution against independent integer expectations, and reports motion/eligible-loop/sweep/visit/fallback statistics. Loop controls must actually have eligible loops and motion; the straight-line control must have neither. The promoted input and optimized output IR are printed in the raw logs for cross-revision identity checks.

The independent interpreter arguments are 0 through 7 and `UINT64_MAX`. These bounded source controls are not exhaustive source or input coverage.

The source campaign has three processes per placement for both adapted variants and four controls: an original bounded loop, original nested loops, an original straight-line function, and SQLite's integer-normalization loops. It contains 96 successful processes and 576 timed summaries. These adapted binaries are explicitly separate from the unmodified-source synthetic binaries. Their costs establish controls through source-derived IR, not a source-compilation timing improvement.

The source fixture replaces the benchmark's historical `nested-loops` slot. In adapter logs and CSVs, use the `source-*` state and printed source filename to identify the actual fixture; the other two synthetic slots remain unchanged. `scripts/check-ir.sh` requires all 24 promoted-input/optimized-output text pairs for each source fixture to be byte-identical across revisions, processes and placements.

## Interpretation

### Unmodified-source pass measurements

| Case/state | Pairs | Baseline vector µs | Candidate vector µs | Paired ratio median [min, max] |
| --- | ---: | ---: | ---: | ---: |
| 4096-chain, interleaved | 12 | 858.001 | 296.146 | 0.3470 [0.3362, 0.3551] |
| 4096-chain, isolated | 12 | 853.009 | 293.868 | 0.3451 [0.3268, 0.3684] |
| 4096-chain, after 200 ms scalar | 2 | 856.119 | 301.492 | 0.3522 [0.3510, 0.3533] |
| 255-chain, interleaved | 12 | 57.024 | 21.054 | 0.3688 [0.3518, 0.3797] |
| 17-chain, interleaved | 12 | 4.801 | 3.745 | 0.7846 [0.7669, 0.7985] |
| No-loop control, 4096 invocation | 12 | 2.975 | 2.979 | 0.9929 [0.9654, 1.0446] |
| Nested-loop control, 4096 invocation | 12 | 3.564 | 3.336 | 0.9347 [0.9174, 0.9667] |

The 4096-chain scalar path moves from 336.007 to 326.931 µs: paired ratio median 0.9711, range 0.9299–0.9875. This scalar drift is much smaller than the vector change and is retained rather than subtracted as a correction. The no-loop controls are near neutral and show small per-pair variation; their paired vector medians at requested lengths 4096/255/17 are 0.9929/0.9957/1.0039. Full per-process, per-placement, scalar and vector observations are in `primary-rows.csv` and the raw logs.

The summary reader treats each process's median of 21 samples as one observation. Its reported candidate/baseline ratios pair matching placement, process, length, state, shape and scalar/vector path; it reports the median and range of these paired ratios. It does not treat the 21 within-process samples as independent observations or present a confidence interval. Two observations in the after-scalar state are a limited sensitivity check.

The reader rejects malformed/incomplete logs, duplicate keys, unknown identities, nonfinite or inconsistent timing ranges, missing/orphan pairs and an incomplete campaign grid. Scalar drift and the small/no-loop controls must be considered alongside the long-chain result. TSC ticks are not core cycles.

`raw/reader-controls.log` records acceptance of the complete source grid and rejection of a removed pair, an orphan candidate, a duplicate key with the same row count, a nonfinite median and an unknown state. Both final campaign readers exit zero; their primary/source CSVs contain 516/576 rows and 24 summary groups each.

The separate two `raw/stats/` adapter runs use one timing sample only to expose the untimed reference-pass work counters. Their timing lines are excluded from performance acceptance. On the long chain, the original vector completion uses 64 sweeps and 267,007 visits; adaptive completion uses one sweep and 8,207 visits. Both fall back, move 4,096 instructions and preserve the checked result. The scalar worklist reports 4,099 visits in both variants.

### Source-derived controls

Each row below has 12 paired process/placement observations. Ratios use paired process medians; the nanosecond columns are medians across processes and need not divide to exactly that ratio.

| Source fixture | IR instructions | Eligible loops / moved | Baseline vector ns | Candidate vector ns | Paired ratio median [min, max] |
| --- | ---: | ---: | ---: | ---: | ---: |
| Original bounded loop | 33 | 1 / 13 | 4,198.38 | 4,017.37 | 0.9575 [0.9214, 0.9843] |
| Original nested loops | 53 | 2 / 22 | 6,890.16 | 6,314.23 | 0.9148 [0.9013, 0.9297] |
| Original straight-line | 9 | 0 / 0 | 1,593.37 | 1,536.31 | 0.9645 [0.9447, 1.0014] |
| SQLite normalization | 44 | 1 / 8 | 5,078.26 | 5,017.14 | 0.9857 [0.9690, 1.0135] |

The straight-line control improves despite having no LICM opportunity. That exposes layout, control-path and measurement sensitivity; these source differences cannot all be attributed to adaptive readiness. Corresponding source scalar paired medians are 0.9951, 0.9989, 0.9785 and 0.9928. SQLite normalization is near neutral. The stronger causal evidence is the long-chain reduction in readiness work coupled with the unmodified-build matched timing campaign. These small source controls do not establish a corpus-wide benefit.

## Correctness and remaining acceptance

Approved-toolchain [CI run 41048834816](https://github.com/buster14a/buster/actions/runs/41048834816) passed on the unchanged candidate: both hosted baseline/native O3 correctness jobs, baseline emulation, complete locked-9700X native-vector correctness, and the final gate. Its ordinary and after-scalar pass benchmarks passed. The CI raw log is retained separately from this matched campaign.

The native CI LICM suite reported 3,205 checks, zero failures.

The original candidate commit has no authentic human DCO/submission-terms certification. This evidence does not create one, rewrite that commit, or authorize a merge. Source readiness, correctness CI, performance evidence and human certification remain separate facts.

## Reproduction and provenance

Install the exact two source trees under the root named by `scripts/build.sh`, with the approved compiler cache available. Run each build through the existing host lock. Run `scripts/run.sh` for the unmodified campaign. For source controls, make separate `source-base`/`source-head` trees, apply the same `source-adapter.patch` to both, rebuild, and place the four fixture files at `loop.c`, `nested.c`, `noloop.c` and `sqlite-normalize.c` under the campaign root. Run `scripts/run-source.sh` and `scripts/check-placements.sh`. Compile `scripts/analyze.c` with `clang -std=c17 -O2 -Wall -Wextra -Werror` and pass each raw-result directory plus output CSV paths.

The adapter, orchestration, analyzer and the three `pr915-loop/nested/noloop.c` fixtures are original project work under Apache-2.0 WITH LLVM-exception. The patch's existing code context remains under the Buster source's retained terms. No external compiler implementation is copied.

`pr915-sqlite-normalize.c` adapts the two normalization loops at lines 38497-38498 of the frozen SQLite 3.53.2 amalgamation, SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Host input: `/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`; the frozen corpus's manifest pins it. SQLite's public-domain disclaimer and blessing are retained in that fixture. Adaptation: expose one unsigned-long input/output, initialize the accumulated loop contribution to zero instead of 40, and return that contribution without the surrounding lookup table. The loop bodies and thresholds are retained. The independent expectation derives the highest set bit and checks `10 * max(floor(log2(x)) - 3, 0)`, rather than rerunning those loops. The SQLite source is an external corpus input; only this identified small public-domain adaptation is included.

New evidence commits are unsigned. The compiler repository's session sign-off authorization is not extended to this separate repository or to historical unsigned commits.
