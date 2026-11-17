# Hosted early feedback and exact reproductions (#1427)

Recorded 17 November 2026 for [Buster PR #2907](https://github.com/buster14a/buster/pull/2907), head `ed0012f24680724c9c66f1b953673e6532169bd9`.
The tested checkout was merge revision `d9394a45486dab26a90806d6fa67cb3b17fbf9b2`, merging that head into `d876a5e0f0252407e467e95dc602b3ad26895f9d` (the build-log excerpt records it).
These are GitHub-hosted CI observations, not compiler-throughput benchmarks. No 9700X/Benchpress execution was used.

## Completed current revision

All four workflow runs passed. The primary run retained four baseline correctness shards and four qualified vector items. Its early check reused the existing shared compiler build; no additional compiler build was introduced for feedback.

| Observation | Actual result |
| --- | ---: |
| First actionable result from run creation (queue/setup/build included) | 360 s (6 min) |
| Early smoke step execution | 7 s |
| Real regression/replay proof step | 4 s; 51 checks passed |
| Required Integration qualification job completed | 854 s (14 min 14 s) |
| Primary workflow completed, including its record | 868 s (14 min 28 s) |
| Primary workflow, every allocated job/attempt | 4,187 runner-seconds = 69.78 runner-minutes |
| This revision, all four PR workflows below | 7,397 runner-seconds = 123.28 runner-minutes |

The early result preceded required qualification by 494 s (8 min 14 s). The three-minute engineering target **was not achieved**. The smoke's seven-second execution is not first-result latency.

There is **one completed qualifying revision** in the current-head sample: first-result p50 and p95 are both 360 s; primary-workflow runner-minute p50 and p95 are both 69.78. This does not estimate population latency or prove a general speedup. There was no controlled A/B comparison; CPU draws, queue/setup and unrelated compiler changes can affect comparisons with historical runs.

| Workflow | Allocated jobs | Actual runner-minutes | Result |
| --- | ---: | ---: | --- |
| [Tests and Zen 5 benchmarks](https://github.com/buster14a/buster/actions/runs/44058962053) | 26 | 69.78 | success |
| [CI latency report](https://github.com/buster14a/buster/actions/runs/44058961878) | 1 | 0.13 | success |
| [Vector claim race fixture](https://github.com/buster14a/buster/actions/runs/44058961852) | 19 | 36.73 | success |
| [Self-host qualification](https://github.com/buster14a/buster/actions/runs/44058961969) | 4 | 16.63 | success |
| All four workflows | 50 | 123.28 | success |

The automated `CI latency report` samples `9700x.yml` (the primary workflow) and counts every allocated job and attempt, including preparation, failed/cancelled jobs, vector redraws and collectors. Its reported cost is not rounded billing time. The additional 53.50 runner-minutes above are supporting-workflow cost, shown separately rather than hidden in the primary metric.

## Retained reproduction evidence

[Early/build feedback artifact](https://github.com/buster14a/buster/actions/runs/44058962053/artifacts/14317098658), with revision, actual CPU, selected host path, settings, pins, exact inventory/runner arguments, logs and `reproduce.sh`. The eight full-shard feedback artifacts are listed in `raw/artifacts-44058962053.json`.
The early host was the explicit baseline `x86-64` configuration; the vector row used its existing qualification pool. Both used Ubuntu 26.04, pinned Clang 23.1.4, O3 and `BUSTER_DEBUG_INFO=0`. Actual CPU identity and host-path proof are retained per execution in the feedback artifacts; no single CPU model is assumed for hosted runners.

To replay, download the appropriate feedback artifact, check out its `revision` in Buster, then run `bash /path/to/artifact/reproduce.sh` from that clean checkout on Ubuntu 26.04. It prefers the original preparation attempt's offline inputs while retained and otherwise reacquires pins and refuses changed apt bytes. A native-host replay additionally checks its CPU model. Feedback artifacts are retained for 14 days; the original input handoff has its own shorter retention. A missing original environment is not a successful replay.

The hosted 51-check proof exercised actual compiler regressions in preprocessing, parsing, checking, object generation, linking, execution and diagnostics. Other fixtures cover conservative dependency selection, unknown/shared/header/policy inputs, documentation exemptions, failed/empty planning, partial inventories with full-row memory admission, failure/incomplete classification, generated replay execution, revision/host-path mismatches and original-handoff reuse/expiry. CI glue and all pre-existing qualification requirements also passed.

## Superseded development revisions

These are earlier revisions of the same PR, not independent representative PRs or steady-state overhead. Their cost is retained rather than reporting only the fastest/successful job. Supporting-workflow costs for these earlier heads were not collected.

| Primary run | Head | First actionable result (s) | Successful smoke result (s) | Runner-minutes | Fate |
| --- | --- | ---: | ---: | ---: | --- |
| [44053966787](https://github.com/buster14a/buster/actions/runs/44053966787) | `741a3ba3ea89` | 17 | not completed | 2.72 | cancelled |
| [44054180211](https://github.com/buster14a/buster/actions/runs/44054180211) | `4c036d139ee8` | 224 | 344 | 48.03 | cancelled |
| [44055442955](https://github.com/buster14a/buster/actions/runs/44055442955) | `ab0e1e03c912` | 318 | 318 | 28.37 | cancelled |
| [44056302436](https://github.com/buster14a/buster/actions/runs/44056302436) | `3ca89c002e61` | 313 | 313 | 28.43 | cancelled |
| [44057188161](https://github.com/buster14a/buster/actions/runs/44057188161) | `2ad41cd17cf9` | unknown | not completed | 18.50 | cancelled |
| [44057794077](https://github.com/buster14a/buster/actions/runs/44057794077) | `a4a2d639df03` | 312 | 312 | 47.28 | cancelled |

These six superseded primary runs consumed 173.33 runner-minutes. With the completed current primary run, captured primary-workflow cost is 243.12 runner-minutes across seven revisions. This is development validation cost, not the incremental steady-state cost of the early stage.

Under the implemented definition, a first result is an early-feedback success or a failed prerequisite/test step. Qualification/coverage aggregate failures caused solely by cancellation are excluded. Cancelled/skipped steps are not passes and missing data is not zero. Across all seven captured revisions there are six first-result observations: p50 312.5 s and nearest-rank p95 360 s. Those mixed development outcomes are not a population-performance claim. The five completed smoke steps have median 318 s and p95 360 s.

## Sources and reproduction of the accounting

`raw/run-ID.json` and `raw/jobs-ID.json` preserve the public GitHub Actions API responses. Each jobs collection used `per_page=100&filter=all`; every response's `total_count` fits its returned jobs, with no missing page. Durations sum each allocated job (`runner_id > 0`) from `started_at` to `completed_at`. API timestamps are UTC and whole-second observations; queued/unallocated jobs consume no observed runner time. All captured current-head jobs are terminal.

The current-head and combined primary observations are `full-run-observations.tsv` and `all-observations.tsv`. Their generated reports are `full-statistics.md` and `all-statistics.md`. From the Buster checkout at the recorded head:

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tools/ci/timings.c -o build/timings
build/timings < /path/to/this-record/full-run-observations.tsv
build/timings < /path/to/this-record/all-observations.tsv
```

The API acquisition for each ID was `gh api repos/buster14a/buster/actions/runs/ID` and `gh api --paginate 'repos/buster14a/buster/actions/runs/ID/jobs?per_page=100&filter=all'`. Collection and quantile semantics are the checked-in `tools/ci/timings.sh` and `timings.c` at the recorded head. New observations here are original accounting of this repository's own public CI facts; no third-party implementation was imported.

---
Agent session: 6afc147c-a0fc-8191-ac40-a5d86a4b3061 (OpenAI / Codex session ID; no private session URL is exposed)
Model: OpenAI / GPT-6
