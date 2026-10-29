# Nested sizeof preparation: retained 9700X qualification for #822 / #884

This preserves an **already completed** historical GitHub Actions capture. No new compiler build, test, measurement, archived helper or benchmark was executed while preparing this record. The only new execution was pure data reduction of the retained CSV/log bytes.

The [original run](https://github.com/buster14a/buster/actions/runs/40924808427) and [native job 123630140804](https://github.com/buster14a/buster/actions/runs/40924808427/job/123630140804) completed successfully on October 29, 2026. The original [artifact 12919949895](https://github.com/buster14a/buster/actions/runs/40924808427/artifacts/12919949895), `issue-822-native-evidence`, was created at 18:10:56 UTC with a November 5 expiry. Its exact original ZIP is retained permanently here, alongside all 170 extracted files and the decoded public job log.

## Original identities and source relationship

- Measured workbench commit: `fa9403f590c40e123be7e3caf717ce6b3694afea`, branch `codex/issue-822-work`.
- Baseline: `1a9955ab5c3cb85d6ef6e346f1ab422abc995384`.
- Submitted source PR: [buster14a/buster#884](https://github.com/buster14a/buster/pull/884), head `c18aceb8560f0a384ce08d8cbb94eb1288906082`.
- Original ZIP: **89,121 bytes**, SHA-256 `edef2acd9faaaf3a1e4f3fdef22871b470060715d4af745460c0b8ebae757eaf`. This matches both the GitHub artifact API digest and the captured upload log.

The measured workbench and submitted PR are **different Git trees**. Static preservation checks show identical blobs for all 594 paths under `src/` plus `build.sh` and `tools/ci/setup-benchpress.sh`, including all five changed C files. The Git-tree differences are three workbench-only `.github` files and the PR's contract documentation. [The source-identity receipt](provenance/source-identity.json) records the exact paths/blobs and differences. This is a source/build-input equivalence bridge, not a claim that the workbench job ran the c18 Git commit or a subsequently integrated head.

The historical baseline and candidate **compiler executable bytes and SHA-256 digests were not retained**. Their identities are limited to the checkout/archive revisions, unchanged tracked build inputs, build recipe/toolchain and successful job receipts. Do not invent hashes by rebuilding them. The helper executable and final object bytes that were actually retained have post-preservation byte hashes in [files.sha256](provenance/files.sha256); those hashes do not stand in for missing compiler identities.

## Machine, commands and status

[environment.txt](raw/artifact/environment.txt) records AMD Ryzen 7 9700X, its CPU configuration, Clang 23.1.4 (LLVM revision `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`) and GCC 16.2.1 20260810. The native workflow uses `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`, `BUSTER_ORACLE_CACHE=off`; the log confirms `BUSTER_HOST_VECTOR 1`. The complete source-pinned [workflow](provenance/workflow-fa9403f5.yml), [workbench build recipe](provenance/build-fa9403f5.sh) and [baseline recipe](provenance/build-baseline-1a9955ab.sh) are retained as text, not executed by this preservation process.

The [decoded native job log](provenance/native-job.log) records the runner's machine lock being acquired at 18:07:53 UTC and released at 18:10:56 UTC. Both builds, correctness suites, timing capture and object comparisons were inside that hold. The timing helper was pinned with `taskset -c 2`; its fork/exec children inherit that affinity. The separate object comparisons were under the same lock, with no additional CPU-affinity claim.

The original helper was compiled with:

```text
clang -std=c17 -O2 -Wall -Wextra -Werror .github/sizeof_measure.c -o evidence/sizeof-measure
```

It generates each input, then invokes baseline / candidate-default / candidate-`--scalar` / GCC with `-fsyntax-only -std=gnu17`; the Buster modes additionally use `--time-stages`. There are two forms, six depths (500, 1,000, 2,000, 4,000, 8,000, 16,000), four modes and three repetitions: **144 samples**. Mode order rotates by repetition, with three of the four possible starts. Wall time covers fork/exec/wait measured by `CLOCK_MONOTONIC`; `check_input_ms` is read from the compiler's `time-stage` output. GCC's `-1` stage value means unavailable, not a negative measurement.

The complete grid and logs are retained. The original helper requires successful child exit, no warning/error text and a parsed Buster check-input time, and exits nonzero if a sample fails. The workflow runs it with `set -euo pipefail` and the job succeeded. This establishes successful completion of all 144 samples at capture. The CSV does **not** contain separate per-row exit-status receipts; none have been fabricated in this record.

## Scaling data

All values below are **milliseconds, median of three captured samples**. This differs from the issue's original **best-of-three** table and its older `bc11fddb` baseline. Compare the candidate with this record's own pinned `1a9955ab` baseline and GCC; do not merge the two experiments or infer an absolute timing change between their baselines.

| Form | Depth | Baseline wall | Candidate vector wall | Candidate scalar wall | GCC wall |
| --- | ---: | ---: | ---: | ---: | ---: |
| expression | 500 | 10.598 | 1.059 | 1.103 | 2.870 |
| expression | 1000 | 35.951 | 1.127 | 1.326 | 3.162 |
| expression | 2000 | 135.722 | 1.582 | 1.930 | 4.483 |
| expression | 4000 | 534.644 | 2.334 | 3.051 | 6.886 |
| expression | 8000 | 2136.327 | 4.371 | 5.862 | 11.938 |
| expression | 16000 | 8609.021 | 7.054 | 10.491 | 20.878 |
| type | 500 | 9.705 | 1.129 | 1.117 | 2.909 |
| type | 1000 | 34.869 | 1.123 | 1.353 | 3.241 |
| type | 2000 | 135.152 | 1.491 | 1.842 | 4.201 |
| type | 4000 | 534.176 | 2.309 | 3.035 | 6.940 |
| type | 8000 | 2187.693 | 4.356 | 5.867 | 11.677 |
| type | 16000 | 8594.018 | 6.923 | 10.499 | 21.667 |

The reader's reported check-input medians at the largest depths are:

| Form | Depth | Baseline check-input | Candidate vector check-input | Candidate scalar check-input |
| --- | ---: | ---: | ---: | ---: |
| expression | 4000 | 533.148 | 0.940 | 1.660 |
| expression | 8000 | 2134.331 | 2.184 | 3.681 |
| expression | 16000 | 8605.599 | 4.137 | 7.163 |
| type | 4000 | 532.893 | 0.947 | 1.673 |
| type | 8000 | 2185.216 | 2.295 | 3.735 |
| type | 16000 | 8590.761 | 3.991 | 7.109 |

The finite curves through 16,000 are consistent with removing the quadratic reader work on both candidate paths; the baseline check-input work grows about fourfold on each of the last two doublings, while the candidate approaches a doubling. These measurements do not prove asymptotic complexity for arbitrary inputs or a corpus-wide speedup. The implementation's separate permanent tests assert folded-token work bounds over five forms; this timing capture measures only the two forms above.

The [new data-only reducer](analysis/reduce.py) checks the exact 144-cell grid, original generator inputs, raw log values and diagnostic absence, then emits [summary.json](analysis/summary.json). It runs no compiler or archived code. Run it only to reproduce this post-capture arithmetic:

```text
python3 analysis/reduce.py > analysis/summary.json
```

No timing observations or old CSV values are changed. Minima/maxima and medians are included in the JSON so the three-run spread remains visible.

## Correctness and equality receipts

The native job retains:

| Suite | Checks | Failures |
| --- | ---: | ---: |
| `test-checker --sizeof` | 6,647 | 0 |
| `test-checker-driver` | 35,916 | 0 |
| `test-checker-deferred` | 2,803 | 0 |

The deferred receipt also reports 121 fixtures, 1,188 merges and 30,336 separately read bodies. A complete checker suite was run by the separate hosted job; it is not relabeled as a native suite in this packet.

[objects.txt](raw/artifact/objects.txt) and the successful `set -e` workflow attest baseline/default/scalar object and diagnostic equality for **all 12 generated inputs**. The loop overwrites its filenames: only the **last three 688-byte objects and three empty diagnostic files** are retained. Those final objects are independently byte-identical during preservation. Do not claim that all 36 object files were archived. These particular inputs produce empty diagnostics, so their equality is not a warning-producing-input equivalence result; the separate focused suites cover unevaluated warnings and VLA behavior.

## Preserved files and limits

- `raw/issue-822-native-evidence.zip`: byte-exact original ZIP, including original metadata.
- `raw/artifact/`: all 170 member files, byte-exact, including the original C helper, its executable, 12 generated inputs, 144 logs, CSV, environment, equality and test receipts and final objects. Extracted executable/object copies are stored as data with non-executable Git modes; the ZIP remains authoritative for original archive metadata.
- `provenance/github-*.json`, `native-job.log`: public API/run/job/artifact receipts and decoded original job log, with retrieval time recorded separately from historical event times.
- `provenance/zip-members.json`, `files.sha256`: post-preservation identity checks; not newly invented historical compiler hashes.
- `analysis/`: new static reduction of original bytes, clearly separate from the historical measurement helper.

This preserves the promised #884 scaling/equality packet within its recorded workbench/source-equivalence scope. It supplies no new-current-main integration validation, DCO certification, final-head CI or merge authorization. The original unsigned c18 contribution's authentic certification and any later source/integration acceptance remain separate. No new campaign was started.

## Provenance and license

The original helper carries its Apache-2.0 WITH LLVM-exception notice. Fixtures and new preservation/reduction prose are original project material under the existing repository terms. Clang, GCC, the runner and its libraries are external build/runtime tools; their version/diagnostic text is factual capture, not an imported compiler implementation. Raw ELF artifacts and ZIP bytes are historical outputs retained without relicensing their embedded components. Existing repository notices and component terms remain applicable. No missing historical binary identity, status or measurement is replaced with a rebuilt or fabricated one.
