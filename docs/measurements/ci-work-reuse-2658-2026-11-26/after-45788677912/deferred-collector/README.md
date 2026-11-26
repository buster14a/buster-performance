# Deferred vector first-shard collector experiment

**Deferred from PR #3638.** The prototype accurately records work after a vector
suite finishes, but applying its offsets made the held-out schedules worse. The
compiler repository's `tools/ci/costs.c` was restored to the published
`4d1f2024095f233cba19e8f8135dd99b17b9e264` version. No generated production table,
scheduler, row, shard, detector, workflow or gate changed through this experiment.

[costs.patch](costs.patch) is the complete tested prototype: 151 added and eight
removed lines in `tools/ci/costs.c`, including 18 focused regression checks. The
base commit and original file blob are in [base.txt](base.txt); the tested source
and binary hashes are in [tested.sha256](tested.sha256). The source SHA-256 after
applying the patch is
`44c4ee70a49c40a6b4673075c3b74ae5f49a5df566d40f99bf79faf65ecf7b7b`.

## What it tested

The existing collector excludes draw jobs from first-shard overhead because
their setup and product waits vary. The prototype instead measures only the
interval from the timestamped `parallel` suite summary to the exact timestamped
`Cleaning up orphan processes` runner marker. It requires zero failed and
not-started commands, the workflow's intervening successful `suite<TAB>passed`
qualification record, and no later error annotation. Missing, repeated,
untimestamped or out-of-order markers contribute no overhead sample while
leaving useful command samples available. Qualification matters because a
cancelled job can skip later checks and still clean up without an error line.

The interval uses the existing CPU normalization and nearest-rank median of
first-shard samples minus the median of other shards, clamped at zero. Native
collection is unchanged. Tests cover scaling and medians, large pre-suite waits,
late harmless warnings, timestamp/marker defects, failures and cancellation.
Initial independent format review informed these safeguards; the prototype was
deferred before a complete independent final-patch review.

The strict Clang 23.1.4 build passed. [self-test.log](self-test.log) records
**179 checks, zero failures**, including the repository's generated-table checks.
Collection and `costs check` passed for all 60 baseline logs and all 16 validation
suite logs: [baseline-collect.log](baseline-collect.log),
[baseline-check.log](baseline-check.log), [after-collect.log](after-collect.log)
and [after-check.log](after-check.log). The generated scratch tables are retained
in [baseline/](baseline/) and [after/](after/). The baseline output differs from
the published tables only in the four vector `#: first-shard` lines and their
comments; all command costs, peaks, CPU/revision provenance and native tables
remain identical.

| Vector row | Offset from 60 baseline logs | After-run offset with frozen baseline CPU factors |
| --- | ---: | ---: |
| Plain | 0.0 s | 0.9 s |
| ASan | 0.5 s | 0.0 s |
| TSan | 96.1 s | 105.6 s |
| MSan | 61.0 s | 101.6 s |

The after-only generated tables use the ordinary collector's fallback where one
run has too little CPU overlap; their offsets are 0.0, 0.0, 105.6 and 102.7 s.
The separate sensitivity analysis fixes the baseline CPU factors for comparison.
Its raw intervals and summary are [../post-suite.tsv](../post-suite.tsv) and
[../post-suite-summary.tsv](../post-suite-summary.tsv).

## Why it was deferred

Applying the baseline offsets to the existing three-run command weights made
the held-out validation run's predicted longest TSan shard **8.6% longer**
(975.200 to 1,059.200 s) and its longest MSan shard **4.5% longer** (847.000 to
885.450 s). Four-run weights and offsets improved that run in-sample, but the
leave-one-run-out MSan changes were +3.1%, +6.2%, −7.8% and +4.5%; the TSan
changes were −0.4%, −3.4%, −0.7% and +8.6%. Runner-minutes also increased in the
four-run in-sample comparison. The accurate missing-cost observation therefore
does not establish a scheduling benefit. The complete model results are in
[../sensitivity/sensitivity.tsv](../sensitivity/sensitivity.tsv).

## Reproduction

Use the archived logs and a separate checkout of the recorded base. This replays
the experiment without modifying the published PR checkout or its tables:

```bash
compiler_repo=/absolute/path/to/buster
evidence=/absolute/path/to/ci-evidence
archive="$evidence/after-45788677912/deferred-collector"
replay_checkout=/absolute/path/to/temporary-collector-checkout
toolchain=/absolute/path/to/llvm-23.1.4
result=$(mktemp -d)

git -C "$compiler_repo" worktree add --detach "$replay_checkout" \
    4d1f2024095f233cba19e8f8135dd99b17b9e264
git -C "$replay_checkout" apply --check "$archive/costs.patch"
git -C "$replay_checkout" apply "$archive/costs.patch"
sha256sum "$replay_checkout/tools/ci/costs.c"
"$toolchain/bin/clang" -std=c17 -O2 -Wall -Wextra -Werror \
    -fno-strict-aliasing "$replay_checkout/tools/ci/costs.c" -o "$result/costs"
"$result/costs" --self-test --root "$replay_checkout"

mkdir "$result/baseline" "$result/after"
cp "$replay_checkout/tools/ci/costs/"*.costs "$result/baseline/"
cp "$replay_checkout/tools/ci/costs/"*.costs "$result/after/"
"$result/costs" collect --tests "$replay_checkout/tools/ci/correctness.tests" \
    --output "$result/baseline" "$evidence/logs/"*.log
"$result/costs" collect --tests "$replay_checkout/tools/ci/correctness.tests" \
    --output "$result/after" "$evidence/after-45788677912/logs/"*.log
"$result/costs" check --tests "$replay_checkout/tools/ci/correctness.tests" \
    --costs "$result/baseline"
"$result/costs" check --tests "$replay_checkout/tools/ci/correctness.tests" \
    --costs "$result/after"
```

Before restoration, the saved patch was checked to be nonempty and to reverse
cleanly against the exact tested working file. [patch-stat.txt](patch-stat.txt)
records its scope. After restoration, forward applicability was checked against
the clean published base. The patch and outputs are retained for investigation,
not as an instruction to apply the demonstrated scheduling regressions.
