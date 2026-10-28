# #672 current-e7 throughput validator

`throughput_summary.c` is an original offline C validator/formatter for the
**unchanged** `../method/microarch.c` throughput schema. It does not run a
compiler or access the target. All writes from this subtask are in this
analysis directory. The root has now supplied the complete original JSONL
and child receipts; [OBSERVATION.md](OBSERVATION.md) records the successful
validation, current-source table and limitations. The raw files remain intact.

This record concerns source `e7f89091648f68940b595aadd648841c1ffc3ec5` only.
It is not a causal comparison with historical `92c025e7`, nor an additive
attribution of integrated PR gains. Source MB are decimal (1,000,000 bytes).
No physical DRAM traffic is inferred; the independent #49 event/unit gates
remain unresolved.

## Invocation

```sh
clang -std=gnu17 -O2 -Wall -Wextra -Werror -Wno-unused-function \
  throughput_summary.c -lm -o throughput-summary
./throughput-summary ../target/throughput.jsonl CHILD_ROOT EXPECTED_OBJECT_BYTES \
  > throughput-report.tsv 2> throughput-validation.log
```

`CHILD_ROOT/LABEL/children.tsv` must hold each method-produced receipt. The
object size must come from the qualified same-binary/same-flags correctness
control, not from whichever row happens to be read first. The root's current
official QA receipt reports **2,341,360** bytes; use that only while its exact
binary/input/configuration identity remains the one being summarized.

The program never modifies the JSONL or child receipts. Preserve those raw
inputs even on failure. stdout contains separately prefixed `cohort`, `child`,
`workers`, `validation` and `scope` TSV records; stderr retains validation
failures. No row is silently replaced, repaired, normalized or treated as a
successful sample after a failure.

Exit status is a bit mask:

- **0:** all throughput/child/grid checks pass and every counter row qualifies.
- **1:** at least one structural, cohort, child or complete-grid check failed.
- **2:** at least one parsed cohort's counters are conditional/unavailable.
- **3:** both conditions above occurred. Missing/malformed data need not also
  set bit 2, because their counters could not be interpreted in the first place.

## Validation and report semantics

- Exactly 25 unique labels cover rounds 0–4 × workers 1/2/4/8/15 once each.
  Every row must use `compile`, `./compiler-native`, one compiler lane,
  scalar/timing false, the ordinary counter mode and `tasks=jobs*4`.
- Every input is exactly **9,507,037 source bytes**. Completed bytes must
  equal that size times successful tasks. Every task must appear once in
  its child receipt, with unique PID, recorded status, positive maxRSS and
  CPU time, expected emitted object bytes (zero for a failed task), and a
  CPU from the reported list. Per-cohort CPU lists have exactly `jobs`
  unique IDs, and every listed CPU receives at least one child. Single-worker
  readings use CPU 2, as the pinned method specifies. Numeric ID uniqueness
  does not itself prove physical-core topology; retain the root's topology
  and actual-affinity provenance separately.
- Aggregate statuses, output bytes, maximum child RSS, faults, context
  switches and user/system time must match the child receipts. Time sums
  allow only the bound implied by printing each value to six decimal places.
  JSON throughput/utilization fields are cross-checked against their raw
  source byte/time fields with rounding tolerances. Wall time and RSS are
  positive; integer counters remain exact `uint64_t` source values.
- Compiler failures and missing objects invalidate that cohort for the
  five-round throughput summary. The raw successful/failed counts and
  observed MB/s remain visible. A worker group's median/range is withheld
  unless all its five unique rounds qualify; the report says how many qualify.
- For every worker count, the report gives median/minimum/maximum of the
  five cohort throughputs and **maximum single-child** RSS values. Fault and
  user/system/combined CPU-time columns are five-cohort summaries of each
  cohort's per-child average (`sum/tasks`). The complete per-child raw rows
  allow inspection of the individual distributions. These are not medians
  of all individual children, aggregate simultaneous peak RSS, or summed RSS.
- User instructions, cycles and IPC require a valid workload, **zero counter
  errors**, positive instruction/cycle counts and the recorded minimum
  running percentage **at least 99.999%**, at most 100%. No rescaling is
  attempted: the method retains summed raw counts and only the minimum
  coverage, not per-event enabled/running intervals. Conditional rows show
  `NA` for normalized counts/IPC. A group's counter medians/ranges require
  all five counter rows to qualify as well.
- Normalized counts are per completed decimal source MB; IPC is summed
  user instructions divided by summed user cycles for each cohort. Raw
  branch/miss/retired-op values and counter errors/coverage remain visible.
  Scheduling a raw retired-op event does not establish its semantic validity;
  no physical-traffic or validated retired-op claim is derived from it.

## Original fixtures and oracles

```sh
clang -std=gnu17 -O2 -Wall -Wextra -Werror -Wno-unused-function \
  throughput_summary_test.c -lm -o throughput-summary-test
./throughput-summary-test > test.log 2>&1
clang -std=gnu17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer \
  -Wall -Wextra -Werror -Wno-unused-function throughput_summary_test.c -lm \
  -o throughput-summary-test-sanitized
./throughput-summary-test-sanitized > test-sanitized.log 2>&1
```

Each run creates its own `fixtures-672-XXXXXX` directory; existing fixtures
are never overwritten or deleted. The positive grid includes 25 cohorts and
600 individual child receipts. Fifteen cases check the good grid; missing
and duplicate cohorts; a genuinely failed child and corresponding aggregate;
zero/partial coverage; counter errors/zero cycles; duplicate/missing JSON
keys; duplicate CPU IDs; inconsistent task/source/output counts; and missing
child files. Exact exit outcomes are asserted. Separate oracles check a known
unsorted five-value median/range and rejection of integer overflow,
non-integer count notation and nonfinite values. Both optimized and ASan/UBSan
runs currently report **34 checks, zero failures**. Synthetic fixtures are
tool qualification, not target performance samples.

## Provenance

The two unchanged parser support files are first-party project files from
the compiler repository at `e7f89091648f68940b595aadd648841c1ffc3ec5`:

| Copied file | Original path | SHA-256 |
| --- | --- | --- |
| `vendor/perf_core.c` | `tools/performance/core.c` | `afdfcea784035fcc10a879cdd258f6b0da8e4ddd8847daa82e21fd4b14830691` |
| `vendor/perf_json.c` | `tools/performance/json.c` | `bcc2620858535830c078fc6d47eb8001270517a946259bbb80020be2b2f7b0c1` |

They retain their original notices and `Apache-2.0 WITH LLVM-exception`
license. Their parser rejects duplicate JSON keys, malformed Unicode and
invalid numbers, preserves exact numeric source slices and uses bounded
flat storage rather than input-dependent recursion. Unused support functions
are omitted by the host compiler; no additional dependency is introduced.
The new validator and fixture code are original work under the same default
terms. The performance-repository record has no compiler-only human DCO
certification trailer.
