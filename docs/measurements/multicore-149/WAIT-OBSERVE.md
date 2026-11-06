# Separate pinned wait observations

`wait-observe` is a separate launcher for one instrumented compiler process.
It is not the timing runner and its output is not a performance curve. Do not
run it until the exact compiler correctness prerequisites and hardware queue
are satisfied and the coordinator admits observations. Build it with the same
Clang flags as `runner.c` and identify its executable before use.

Each invocation starts outside the host lock and acquires one fair lock grant
through `exclusive.sh`. Inside the inherited fd-9 lock, it runs the existing
240-second sample guard, 10-second termination grace and up to 5-second orphan
cleanup. Hashing, the instrumented compile, trace validation and byte
comparisons all occur inside that guard. A timeout, signal, unclean descendant,
missing receipt or other failure makes the observation incomplete. In
particular, a failed outer wrapper may exit before detached guard cleanup;
its elapsed time is not an upper bound on lock hold.

The launcher is intentionally pinned to the exact merged 2dc compiler tree,
the independently built instrumented binary, and the qualified uninstrumented
binary and reviewed validator identified in `wait-observe.c`. It checks clean
control and exact patched diagnostic source trees, executable and applied-diff hashes,
host policy and environment, and the timing case's input hashes before and
after. The `--qualified` directory must be one independently reviewed, fully
qualified timing case whose retained one-lane reference and input manifests
match. The launcher checks the 82 expected sample, guard, identity, policy,
environment and object-hash receipts and the presence of a summary; it does
not recompute the summary or reparse historical stage stderr. These structural
checks do not replace independent full-record review. Every diagnostic
object must be fresh, regular, nonempty and byte-identical to that reference;
the reference's own object hash receipt is rechecked. The launcher supplies
`BUSTER_WAIT_TRACE=1`, pinned lane CPUs `0..N-1`, `--time-stages`, and a PID
captured before exec. It checks the actual child status and validates complete
lane/pin/metric/calibration records against that PID and CPU list. It retains
raw stderr/stdout, the own-lock receipt, guarded status, source/binary
identities, input snapshot and object hash receipts, including failures.

```sh
"$tools/wait-observe" --qualified "$campaign/results-sqlite" \
  --output "$campaign/wait-sqlite-4" --control-source "$compiler_tree" \
  --diagnostic-source "$diagnostic_tree" --lock "$lock" \
  --validator "$performance_tree/docs/measurements/multicore-149/wait-diagnostic-merged-2026-11-06/validate-wait.py" \
  --lanes 4
```

The output directory must be new. Run each case and lane count as an independent
invocation and preserve failures. `observation-status=validated` means only
that this one perturbed observation met its identity, trace and byte-equality
checks; it does not establish a complete campaign. The worker TIDs are checked
for positivity and uniqueness, but are not independently corroborated by this
launcher. Histogram intervals include instrumentation, scheduling and clock
costs, omit non-session threads and later terminal parking, and do not prove
C-state residency or frequency effects. The 1–10 ms bucket cannot count waits
above 1.5 ms exactly. See the diagnostic methodology for those limits.

For the separately coordinated prerequisite smoke only, `--smoke` permits a
failed/incomplete timing case whose retained one-lane reference independently
passes the same identity, input, status and object-hash checks. A successful
smoke writes `observation-status=smoke-passed` and `observation-scope=smoke`;
it never writes a validated campaign observation. Normal mode rejects incomplete
cases. Both modes use the same guard, source checks, trace validation and object
comparisons. Keep smoke receipts distinct from the later campaign.

`wait-observe-test.c` tests multi-object reference and comparison failures;
`test_wait_observe.py` exercises the launch boundary and verifies that the PID
is preserved across exec. The existing runner self-tests cover the reused guard
and process cleanup, while the independent validator suite covers malformed
trace rows. Synthetic tests do not admit hardware or publish observations.
