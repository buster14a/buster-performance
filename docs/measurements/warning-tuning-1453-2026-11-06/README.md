# Declaration-warning tuning follow-up (#1453)

This follows the [initial warning-cost investigation](../warning-diagnostics-1453-2026-11-06/README.md) for [buster PR #1453](https://github.com/buster14a/buster/pull/1453). On one frozen SQLite syntax-only workload, the branch was slower than repaired main. This record preserves intermediate tuning samples and a final interleaved comparison; it does not establish corpus-wide performance or remove the PR's remaining performance blocker.

Each intermediate candidate was built from the specified commit with Clang 23.1.1, Release O3, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`, and run three times under separate 9700X shared-lock grants. Samples use CPU 2 and `perf stat` user instructions/cycles, with the same source, flags, and executable path. Every event ran for 100% of its interval. These are separate batches and must not be treated as paired cycle estimates across commits.

| Candidate | Change at commit | Median instructions | Median user cycles |
| --- | --- | ---: | ---: |
| 2 | shared reach classification `e8a376e6` | 1,458,808,007 | 613,842,624 |
| 3 | skip impossible fallthrough walk `cebce182` | 1,431,890,388 | 597,576,370 |
| 4 | source-first candidate filtering `c2b5433f` | 1,431,577,824 | 596,960,949 |
| 5 | vector source-context scan `ac99079b` | 1,430,426,007 | 597,824,425 |
| 6 | prune redundant ordinary walk `22b3e7b4` | 1,428,717,799 | 593,850,598 |
| 7 | same-type integer filter `1f88c53a` | 1,422,893,410 | 595,991,657 |

A subsequent confirmation compared candidate 7 with repaired main `a581e20b` in three interleaved pairs. Median instructions were **1,363,327,836 / 1,422,893,231 (+4.37%)** and median user cycles **566,843,131 / 592,221,528 (+4.48%)**. Compiler stdout and diagnostics matched across all six processes. The result is one workload and three paired samples, not an assertion about other workloads. The compiler PR remains draft while the remaining difference is investigated.

## Identity and receipts

- Base `a581e20b8cd202196d8f2dcfff22ce7a5e09e9b6`, compiler SHA-256 `5c07df7932e9579424c4827ef6e129317f8d8d29fe5a00750414faa149a5bc04`.
- Final candidate `1f88c53a59885e3ddb2a32d966561e412ed021de`, compiler SHA-256 `a2df9fc76bcd0bfca7294ddee9b7765a6a8287d8c353bac1fafef0fd5d7fdfbd`. The intermediate executable hashes are in the corresponding `candidateN.sha256` files.
- Frozen `sqlite3.c` SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; flags and worktree paths are in the scripts under [raw](raw/). Linux `6.18.50-2-lts`; CPU governor `performance`.
- The final comparison's six `.receipt` files, normalized only to remove trailing whitespace, contain `held=1`, lock-owner state before and after the measured process, compiler hash, successful status and output hashes. All stdout files were empty; all compiler diagnostic files hash to `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35` and are retained alongside the receipts.
- The intermediate scripts also invoke the shared lock individually; positive lock-owner receipts were not captured for those historical runs. Their sanitized diagnostic outputs are retained without unrelated lock-holder messages. Each hashes to the same diagnostic value above. Intermediate build identities, commands and raw perf counters are in [raw](raw/).
