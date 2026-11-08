<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
# Historical #1740 SQLite output-mode diagnostic, V3

This appendix adds the completed **historical `84618358` → `b48aba85`**
default-`-c` SQLite diagnostic and its initial failed-format attempt. The parent
[CI record](../README.md), its raw log and receipt are preserved without edits.
Those older CI program/rows workloads and these new compiler observations have
different revisions and timing protocols; they are not pooled.

The V3 controller made **42 observations: six warm-ups and 36 measured compiles**,
with fresh and reused output modes and base/head/base-again roles. Each
observation obtained its own fair shared-9700X grant. Mode order alternated and
role order rotated through every position twice. No compiler rebuild, generated
program execution, trace, profile, tuning or new source candidate was part of V3.

## Observed results and limits

The values below are ratios of six-observation medians, excluding warm-ups.
Elapsed is the new `perf stat` command interval, **not CI release-to-wait4 wall**,
the queue-inclusive wrapper wall, or the guard's monotonic duration.

| Output mode | Base elapsed ms | Head elapsed ms | Head/base | Base-again/base |
|---|---:|---:|---:|---:|
| reused | 112.919141 | 137.284960 | 1.215781123 | 0.997563252 |
| fresh | 112.741013 | 112.856063 | 1.001020480 | 0.999950497 |

Reused-mode matched-round head/base elapsed ratios range from **1.166447 to
1.284404**; the fresh range is **0.947910 to 1.028086**. Repeat-base ranges are
0.941679–1.054087 reused and 0.965624–1.023269 fresh. These are observed controls,
not confidence intervals. Ratio-of-medians and median paired ratios are separate
statistics in the [independent review](INDEPENDENT-REVIEW.txt).

User-cycle ratios are 1.000635806 reused and 0.997906059 fresh; instruction ratios
are 1.000015596 and 1.000015608. Small cycle differences must be read beside the
base-again variation. All seven events, both raw tuple families and every observation, range,
paired ratio and zero-denominator case remain in the data files.

The reused head's higher elapsed time is a **conditional association**. Every
reused head write shrank the object from 2,333,400 to 2,331,800 bytes, coupling the
compiler binary and output-size transition. This does not identify an I/O cause
or establish a general compiler regression. Code-size differences and the earlier
generated-lexer findings are investigation leads, not established causes of these
compiler timings. This V3 default-`-c` protocol does not measure generated lexer
runtime or the six CI program runtimes.

All 42 status/guard checks passed. Independent parsing reconciles 588 raw event
rows and 294 normal summaries, with positive exact enabled/running equality and
matching indexed/aggregate values. Twenty formatter controls passed before the
cohort. All mixed stderr streams equal the reviewed 4,451-byte formatter fixture;
stdout is empty. This is combined-stream byte identity, not a separate broad
compiler-quietness claim.

CPU2 affinity probes and 84 before/after policy snapshots are retained; snapshots
do not establish continuous in-window policy stability. Named-file bindings cover
the recorded compiler/input/guard/helper/reader/fixture/perf and named tool files.
They do **not** prove a transitive header, runtime or toolchain dependency closure.
No syscall tracing was admitted.

## Output state and failed attempt

Twenty-one fresh objects, two per-compiler references and the final reused head
object remain privately retained and were independently rehashed. Earlier reused
contents were overwritten by the single-path protocol; their state/hash and
successful per-compiler byte comparisons are collector receipts, not separately
retained bytes available for independent rehash.

The initial V2 attempt stopped after one base warm-up: the empty-stderr assumption
rejected perf's verbose formatter output. Compiler/perf status was zero; the helper
exited 1 and the guard recorded encoded wait status 256 (exit 1). No measured cohort
was accepted and publication/reference
checks were not reached. It is retained as failure evidence, excluded from every
V3 statistic. Only its explicitly reviewed formatter-byte fixture was reused;
no failed object, timing, warm-up or reference crossed into V3.

The actual later maintainer merge and subsequent main revisions were not measured.
This appendix does not close #1217 or satisfy its unchanged #1189 dynamic
non-frame LEA/power-of-two IMUL and corpus dispatch acceptance gates.

## Files, publication copies and verification

- [RESULTS.md](RESULTS.md), [cohort-receipt.json](cohort-receipt.json) and
  [PROVENANCE.txt](PROVENANCE.txt) preserve the executor's frozen interpretation,
  full pins, guard lineage, control scope, commands and limits.
- [individual-observations.tsv](individual-observations.tsv) retains all 42 rows;
  [paired-ratios.tsv](paired-ratios.tsv) retains 120 metric/round records;
  [recomputed-summary.json](recomputed-summary.json) retains exact raw-integer
  and midpoint-median summaries. [INDEPENDENT-REVIEW.txt](INDEPENDENT-REVIEW.txt)
  independently checks the raw records and recomputation.
- [PUBLIC-TEXT-REVIEW.txt](PUBLIC-TEXT-REVIEW.txt) independently checks the actual
  archive, original/public mapping and inspected sanitizer changes. Its scope is
  this concrete archive, not arbitrary future holder metadata.
- [sqlite-output-mode-v3-text-2026-11-08.tar.gz](sqlite-output-mode-v3-text-2026-11-08.tar.gz)
  is a **159,568-byte text-only publication archive**, containing 1,113 regular
  files from V3, preparation/controls and the failed attempt. No objects, binaries
  or corpus source archives are incorporated.
- [PUBLICATION-MAP.tsv](PUBLICATION-MAP.tsv) records each archive member's original
  and public SHA-256/size. Exactly five copies differ: unrelated shared-lock
  holder blocks from three CI holders, including two byte-identical preparation-log
  duplicates, were replaced with an explicit marker. The approved sanitizer source
  is retained in the archive; original raw files remain unchanged. No own grant,
  measurement, diagnostic, status, counter, state or policy bytes were removed.
- [EXCLUDED-ARTIFACTS.tsv](EXCLUDED-ARTIFACTS.tsv) inventories 27 privately retained
  objects/binaries by hash and size. [PUBLIC-CONTENTS.sha256](PUBLIC-CONTENTS.sha256)
  verifies the extracted publication copies. Original manifests retain original
  paths/hashes, including omitted artifacts; they are not substituted for public hashes.

At this appendix root, `sha256sum -c SHA256SUMS` verifies the published files.
After extracting the archive into an empty directory, run
`sha256sum -c ../PUBLIC-CONTENTS.sha256` there. Archive ownership, modes and
timestamps are normalized for reproducibility; all member contents follow the
published mapping. No archival preparation command runs a compiler workload.

Original report/curation and helper work follow Apache-2.0 WITH LLVM-exception.
Retained helper notices and factual external tool output keep their existing
terms; this appendix asserts no new license over third-party output. SQLite,
system headers/runtime files, Clang and perf implementation sources are external
inputs and are not incorporated.

---
Agent session: 01a1b81e-6ae2-7022-84e9-95739850f990, task /root/review_diagnostics;
measurement /root/review_codegen; independent saved-data review /root/review_calls;
sanitizer source review /root/review_calls/integrate_parser;
coordination /root (OpenAI Codex session ID; no private URL is exposed)
Model: OpenAI / GPT-6 (exact runtime variant not exposed)
