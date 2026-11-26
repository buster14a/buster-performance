# Validation and provenance

This receipt covers the November 26 continuation of [buster #1439](https://github.com/buster14a/buster/issues/1439). The production observations are frozen at the ledger and source commits in `README.md`; they are not a new benchmark campaign.

## Reporting change

Code commit: [`16111ffac992a7447280851a1164d436d148e428`](https://github.com/buster14a/buster/commit/16111ffac992a7447280851a1164d436d148e428), based on `8e4d32879e17b7d9548cad54257a2f8461328366`, branch `codex/1439-nightly-snapshot-verdict`.

Pull request: [buster #3649](https://github.com/buster14a/buster/pull/3649).

The tested local commit was `a1c2cfd67d3c422f23f611f1538dcd137293a2a2`. Git push had no credentials in the execution environment, so the connected GitHub API published the same parent, Git tree (`aab7ffe1a7d66f7c3dab02a4164525a4bcd32af7`) and complete commit message, including its single sign-off trailer. The API's commit identity/date produced the published hash above. Both tree and message were read back and checked; there is no source-content difference from the tested local commit.

The change adds 257 lines in `tools/ci/nightly.c` and 15 lines in `docs/ci.md`. It reports the current cycle's latest admitted snapshot attempt, using the existing run-ID/attempt ordering. It requires a recorded full/admitted/complete outcome for completion, reports pending or unharvested attempts conservatively, names pin/substitute and exact target, and retains failed/blocked/interrupted counts. It changes no planner action, retry, hardware window, request or ledger schema.

The reported result means native correctness and full measurements. A separate hosted/sanitizer/fuzz preparation can have a different outcome; November 13 demonstrates that distinction in production. The source audit in `recovery-audit.md` describes the base revision before this reporting change.

## Local checks

The final two-file diff was reviewed without further edits before committing it. `git diff --check` passed. The test entry point and all integration fixtures are the existing repository scripts.

| Check | Result |
| --- | --- |
| Fixture selector | 39 cases and reporter cleanup/status checks passed |
| Optimized nightly self-test | 343 checks, zero failures |
| ASan/UBSan nightly self-test, leak detection disabled for the local environment | 343 checks, zero failures |
| Complete network-free nightly integration fixtures | Passed; exit 0, 1,164 seconds including cleanup |
| Commit sign-off | Required trailer appended once by the repository's authorized worktree hook and read back |
| DCO structural API audit | Passed: one signed commit, zero missing, zero trailer findings; complete one-commit PR listing |

The initial unmodified command `bash tests/ci/nightly.sh` passed its optimized self-test, then LeakSanitizer aborted with its fatal ptrace-environment diagnostic (exit 134). This is not recorded as a clean leak-enabled test. The complete rerun used:

```sh
LSAN_OPTIONS=detect_leaks=0 bash tests/ci/nightly.sh
```

The rerun retains address and undefined-behavior sanitizers and the same integration fixtures. Leak checking remains unverified locally and should run in ordinary hosted CI. Both the initial diagnostic and final rerun output are retained under `recovery/` in the raw evidence archive. No compiler build, hardware benchmark, workflow dispatch or manual rerun was performed for this audit.

The full integration run checked evidence and records, merge-queue qualification and stale candidates, first-parent states, the ledger, historical worker windows, dry/real coordinator behavior, overrides, failed polls, refilled preparations, refused/failed/raced branches, pending compaction, prepare-to-window handoff, and a pinned snapshot after main moved past it. `git show --check` passed for the committed change.

## Independent review

The reporting change was reviewed by the parent session and two additional agent tasks beyond its author. Reviews checked admission/cycle filtering, latest run/attempt ordering, pending visibility, pin validity, full-coverage requirements, failure retention and the absence of planning changes. No code blocker remained.

The ledger and hardware timing analysis were independently recomputed from retained records. A separate delivery review checked all table joins and file references: 22 retained report dates, 20 corrected cycles, 20 preparation/admission pairs, 11 native inventory rows, all 40 November 26 intervals, 19 distinct states, and the seven/eight-job timing inputs. It verified every exact lock-hold difference, the disjoint window intervals and the 16,351.5595482-second total. Published reproduction paths were corrected to the delivered filenames.

These are agent reviews of the stated evidence and change; they do not replace the maintainer's merge review or certify future nightly behavior.

## Evidence and replay checks

All 23 ledger/report files were verified against the Git blob identities at `bf8108aa9d8257f6dbe6049013f1832bd913c1e8`; `ledger/source-manifest.json` retains the source identities. Every retained JSON evidence file parsed successfully. The audit retained all 40 latest worker job lists/hooks and read the full logs for eight successful snapshots, the three latest unsuccessful snapshots and two representative backlog jobs.

The original CI timing artifact has 194 entries, 2,318,359 bytes and SHA-256:

```text
941b7690d65727b3b5be4362733009385b66e699745de637cd70ddaaf2d335e6
```

The existing collector/reader was replayed entirely offline using the extracted artifact:

```sh
CI_TIMINGS_REPLAY=EXTRACTED_ARTIFACT GITHUB_REPOSITORY=buster14a/buster bash tools/ci/timings.sh OUTPUT
```

Replay exited zero. All meta/run/job/step facts and all summary metric tables before the collection notes were byte-identical. The five relevant source blobs at artifact commit `09c3b79bab04f0e1b37afbef611a9e7f0937b055` match the audit base. Offline replay has 19 notes versus the original 45 because it does not repeat 24 failed log fetches and two failed branch fetches. The original unavailable-read notes remain in the ZIP; the complete summary files are therefore not claimed byte-identical. `workers/timing-replay-receipt.json` retains exact hashes and this distinction; `workers/timing-source-blobs.json` records the source comparison.

The existing C timing reader separately reproduced the successful-backlog and successful-full-snapshot tables from the delivered TSV inputs. All-outcome occupation statistics retain failed runs; those runs are not relabeled successful to fit the reader's success-only output.

## Package and publication

The raw archive contains `cycles/`, `ledger/`, `recovery/` and `workers/` plus an internal `SHA256SUMS`. Subdirectory manifests were regenerated after collection and validation ended. The outer `SHA256SUMS` covers every delivered file except itself, including the raw archive and the original timing ZIP. Archive contents and hashes are verified before publication. The enclosing Git commit pins the published report.

Evidence is committed directly to `buster-performance/main` under the repository's measurement-storage policy. The compiler change is submitted through a separate PR for the maintainer to merge. Post-publication CI state belongs to that PR and the issue handoff; this receipt records the pre-publication checks above.

The compiler commit's new original code, tests and documentation use the repository's existing terms. The commit hook applied the maintainer's standing direct-session certification prospectively. That compiler-repository certification is not extended to historical commits or to the separate performance repository. New report prose and derived tables are original project work; retained repository records/logs keep their source provenance. No external implementation, test corpus, unmasked credential or signed download URL is included.

#1439 remains open because the observed capacity and completion criteria fail. The reporting fix is not evidence that the new snapshot behavior has been deployed or that a subsequent production cycle has passed. Current work is linked to #1362, #2870, #2029 and the newly filed independent-observer follow-up #3627.

---
Agent session: 6b07ef78-8230-83ed-a344-72666686206a (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
Contributing tasks: /root/ledger_audit, /root/cycle_audit, /root/recovery_audit (same parent session and model)
