# Provisional per-lane wait diagnostic

This is an **unqualified diagnostic prototype**, not the compiler or executable
used for timing curves. Its immutable compiler base is Buster PR #1528 head
`e1fa1575b0ee112ecac733e09eb727cbbad4df64`. That revision has not completed
acceptance. The additional local build repair is a provisional patch from
[#1522](https://github.com/buster14a/buster/pull/1522) head
`798a7a11b40bca98b9043613018ebaa0ba5ed741`; it is not evidence that main or
the pinning PR passed. Rebase, independently review and requalify the final
compiler and diagnostic before using this on the 9700X.

[`apply-diagnostic.sh`](apply-diagnostic.sh) checks both patch hashes, requires
that exact commit and tree, a clean repository root with no hidden-index flags,
ignored files or existing `build` directory, and checks both patches before
applying them. It refuses any other source
revision, even a later fixed version. Use it only on an isolated checkout. The
separate [`test-applicator.py`](test-applicator.py) creates a disposable clone
and checks wrong revision or replacement tree, assume-unchanged and
skip-worktree flags, existing build, tracked, untracked or ignored files and a
tampered patch, then checks the resulting three source hashes.

The changes are in [`instrumentation.patch`](instrumentation.patch) and
[`provisional-1522-build-repair.patch`](provisional-1522-build-repair.patch).
They are zero-context diffs; the applicator permits those only after verifying
the exact clean base and the patch hashes.
For a local reproduction, first obtain a clean, fresh checkout at the exact
base, then run the applicator and build with the ordinary repository build
script and the diagnostic definition:

```sh
./apply-diagnostic.sh /absolute/path/to/isolated/compiler
cd /absolute/path/to/isolated/compiler
BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES=-DBUSTER_LANE_WAIT_DIAGNOSTIC=1 ./build.sh --config Release
./build/compiler test-lanes --rounds 10
```

Use the local physical-core scheduler for each build/test on the shared local
machine. On Benchpress, first satisfy the current compiler's review and native
qualification, then use the 9700X's shared lock **per run**, the approved
`znver5` host target and the corresponding current reviewed patch. The commands
above describe the 7940HS prototype and do not authorize a benchmark campaign.
The 9700X timing executable must be built separately without this patch and
without the diagnostic definition.

For a separately labeled diagnostic run, set `BUSTER_WAIT_TRACE=1` and pass the
reviewed driver's `--lanes N --lane-cpus LIST` along with `--time-stages` and
the exact workload arguments. Verify both the driver's lane-pin receipts and
the diagnostic lane/CPU records. Without that environment variable the
instrumented executable does not emit the wait records; it remains a distinct
instrumented build and must not become the timing executable.

## What is observed

Each explicitly pinned **session lane** keeps thread-local counters from session
startup through return from the command flow. It emits its lane index, TID,
requested and observed CPU, clock calibration, and histograms for:

- the initial PAUSE spin loop;
- intervals around each executed MWAITX instruction;
- the PAUSE fallback when built without MWAITX;
- futex calls reached from a barrier's fallback;
- other recorded futex calls, including session startup and helper-board parks.

Each category separates returned-zero/completed calls, EAGAIN, EINTR and other
errors; every outcome retains elapsed intervals. Histogram boundaries are 1,
10, 100 microseconds, 1, 10 and 100 milliseconds, and 1 second. Each record
includes call count, failed clock-read count, total and maximum elapsed
nanoseconds and eight bucket counts. A returned-zero futex call and a returned
MWAITX call are not classified by wake reason. A clock calibration records
1,000 consecutive `CLOCK_MONOTONIC_RAW` pairs per lane after the flow.

These are **inclusive instrumented wall intervals** around code and syscalls.
They include clock and loop overhead, interrupts, preemption and scheduler
latency; the clock samples and output themselves perturb the workload. The
initial-spin row covers the loop and its reads, not just PAUSE instruction
residency. MWAITX intervals are not hardware C-state residence, and none of these
rows measures a subsequent frequency effect or an uninstrumented waiting-time
distribution. Do not infer elapsed wall time by summing concurrent lanes.

Only the owner and worker threads of the pinned session activate this TLS
instrumentation. Cold `lane_run` threads, separate `lane_team` workers, and
other helper or library threads are outside its scope. A diagnostic session
forces a worker join after flow completion so the snapshots are emitted before
process exit; the production terminal path can park those workers instead.
Consequently the data excludes later terminal parking and its end policy differs
from the timing binary. Rows are for investigation, not speedup measurement.

## Provisional local validation

[`provisional-local.tar.gz`](provisional-local.tar.gz) contains source/patch and
binary hashes, build and test output, a generated 200-function source, compiler
arguments, the raw diagnostic records, CPU lists, a row validator and output
hashes. Compiler binaries and objects are not distributed. The diagnostic and
an uninstrumented control were built in separate checkouts on a Ryzen 9 7940HS;
both included the provisional #1522 repair.

`test-lanes --rounds 10` passed, including actual futex wake, EAGAIN and EINTR,
clock reads, lane identity, accounting and a timed MWAITX invocation on this
host. A separate four-pinned-lane source compile produced four matching
lane-pin/diagnostic CPU identities, 80 consistent class/outcome rows and four
clock calibrations. Its object matched the one-lane uninstrumented control
byte-for-byte, SHA-256
`27fe440cddf47d09239327430ded9f391efbb7ba760cc23b6e5ed0a7f153f531`.
The patch applicator's refusal and reproduction tests also passed. These are
bounded prototype checks, not acceptance on the 9700X or on the final compiler.
Other sessions' core-queue holder details were removed from the published log
copies; the original working logs remain local.

---
Agent session: 01a1b0e0-a314-7252-9c29-d958f2e64d73 (Codex session ID; agent thread 01a1b0e1-da73-7731-9bcf-4312e3561034; no private session URL is exposed)
Model: OpenAI / GPT-6
