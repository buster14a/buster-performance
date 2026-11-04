# Acceptance handoff for buster#1175

The compiler changes landed in [buster#1225](https://github.com/buster14a/buster/pull/1225).
The remaining acceptance is the **paired 9700X measurement**, not another copy of those changes.

The integrated pair, verified against the merge commit's first parent on 2026-11-04, is:

| Role | Buster commit |
| --- | --- |
| Reference | `e36740b8f70cf5755cabff9b2a9a998b173c2878` |
| Candidate | `c79fd0076fc8ee3ba0a43d02f94dca417a7557ea` |

The earlier BOLT results in `README.md` are historical evidence for their own revisions.
They are not hardware-cycle results for this integrated pair. This handoff adds no hardware measurements.

## Running the campaign

From a checkout of buster-performance containing this reader and campaign revision, on the 9700X:

```sh
git -C "$HOME/buster" fetch origin main
CAMPAIGN_DIRECTORY="$HOME/buster-fast-bench/layout-1175-$(date -u +%Y%m%dT%H%M%SZ)" EXCLUSIVE_OWNER=layout-1175 EXCLUSIVE_TITLE="Checker layout acceptance #1175" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1175 bash docs/measurements/layout-hints-1175-2026-11-03/scripts/campaign-9700x.sh "$HOME/buster" main=e36740b8f70cf5755cabff9b2a9a998b173c2878 head=c79fd0076fc8ee3ba0a43d02f94dca417a7557ea
```

Record the exact buster-performance commit used. Use a fresh campaign directory so earlier failed attempts cannot
supply stale receipts. The script retains the existing four in-section placements, frozen corpus, three repetitions
per counter, object comparisons and `time-runs --runs 11 --warmups 1 --copies 2`. It takes the shared lock per run;
the counter-reader build now also takes that lock. No pull-request or merge-queue hardware job is added.

The within-section offsets matter: moving only the whole page-aligned checker section does not test different
offsets within its page. Verify the offsets recorded in `receipts.txt`; do not replace them with ordinary whole-page
shifts. All eight executables must emit the reference's 140 objects byte for byte.

## Counter completeness

The campaign writes `logs/counters-expected.txt` independently of perf's output. For the default pair it declares
216 observations: two builds, four placements, three modes, three repetitions and three events.

The reader now requires this manifest:

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror scripts/counters.c -o /tmp/layout-counters
/tmp/layout-counters "$CAMPAIGN/logs/counters-expected.txt" < "$CAMPAIGN/logs/counters.txt" > "$CAMPAIGN/logs/counters-summary.txt"
```

These commands are relative to this record's directory, with `CAMPAIGN` naming the completed campaign directory.
On the 9700X, wrap standalone builds and runs with the shared `exclusive.sh` lock as in the compiler's agent guide.

The manifest must describe at least two builds and a complete rectangular grid with consecutive repetitions.
Each declared observation must occur exactly once. Missing or duplicate samples, unknown dimensions/repetitions,
malformed rows, unavailable perf values, non-finite values, counts below one and counts outside the reader's
`[1, 2^64)` numeric range fail before a comparison is printed. Input and output errors fail too.
The reference is the first build declared in the manifest, not whichever observation arrives first.

The summary retains the original statistic: least count over repetitions, mean over placements, and the range of
all candidate/reference placement combinations. It does not automatically declare performance acceptance.
The full unfiltered output of every perf invocation is retained as `logs/perf-*.csv`, including counter runtime
and scaling information. The collector clears an old summary before starting counter collection.

## Reader qualification, not performance evidence

The original reader was reproduced from blob `587b04f7f19af822dcc50dfeeb8725927b079f11`. It returned success for a
two-row incomplete experiment, duplicate observations, `nan`, and a zero reference count that printed an infinite
percentage. The original campaign was reproduced from blob `d9375f836b25a66ef6a1b072a66bfc651ebcc6a8`.

The regression fixtures are original, synthetic data generated in `scripts/counters-test.c`; they incorporate no
compiler corpus or third-party implementation. Run them from this directory:

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing scripts/counters-test.c -o /tmp/layout-counters-test && /tmp/layout-counters-test
clang -std=c17 -O1 -g -Wall -Wextra -Werror -fno-strict-aliasing -fsanitize=address,undefined -fno-omit-frame-pointer scripts/counters-test.c -o /tmp/layout-counters-sanitized && /tmp/layout-counters-sanitized
```

Validation performed in the editing container:

- All 48 C fixtures passed with GCC and Clang, at `-O2`, with Clang at `-O3`, and under AddressSanitizer plus
  UndefinedBehaviorSanitizer. An independent UndefinedBehaviorSanitizer build passed too.
- A complete 216-row fixture produced exactly the original reader's summary. Twenty-five shuffled permutations
  preserved that summary and the manifest's reference build.
- A write to `/dev/full` and an unreadable manifest stream returned failure.
- The campaign's actual counter-capture block passed four shell-level tests with stand-in `perf` and `taskset`:
  complete data (216 rows, 72 raw files), a wholly missing cycles event (144 rows), no events (zero rows), and
  a failing perf process. Only complete data succeeded. Every failure left the summary empty, including when
  an earlier summary existed.
- `bash -n` passed for the updated campaign. These tests did **not** build either compiler revision, check its
  objects, run `time-runs`, or execute on the 9700X.

## Completion remains open

Publish the real campaign receipts, manifest, raw perf logs, reduced counts, summary and timing output in this
performance repository, together with the exact source/harness/tool/input identities. Evaluate taken branches
**and cycles** over placements, report any regression or noise rather than treating branch reductions as proof
of speed, and record the remaining profile-layout gap in the compiler's design summary.
Do not close buster#1175 based on these synthetic validation tests.
