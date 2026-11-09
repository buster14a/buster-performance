# Merged-source per-lane wait diagnostic

This **unqualified diagnostic prototype** targets the exact merged compiler commit `2dc50258e8b33393474b64032a5cbe9f17c63def` and tree `1829aa50f677d713bcb250966746575d526989ef`. It is a separate instrumented binary, not the compiler used for timing curves. The commit has not yet been qualified by this record for native acceptance; independently verify its hosted and native correctness and coordinate the hardware campaign before use. The older [prototype](../wait-diagnostic-prototype-2026-11-06/README.md) and its provisional repair remain historical evidence.

The instrumentation patch is byte-identical to that previously reviewed for PR #1528 (SHA-256 `a3c1b07813bea6ed47d50d1f5d84f2d927ce69eb55aa560d8751aba47cdda80d`). The obsolete #1522 build repair is not applied: the merged compiler tree already contains the relevant fixes. `apply-diagnostic.sh` verifies the patch digest, exact commit and tree, clean tracked and untracked state, index flags, absence of ignored files and build directory, and patch applicability before mutation. Use it only on a fresh isolated checkout. `test-applicator.py` creates a disposable clone and checks wrong commit or replacement tree, hidden-index flags, a build directory, tracked/untracked/ignored files and patch tampering before checking exact resulting source hashes. The local [applicator test output](applicator-merged-test.log) and [merged identities](merged-identities.txt) are retained.

For local reproduction, after reviewing the host policy:

```sh
./apply-diagnostic.sh /absolute/path/to/isolated/merged-compiler
cd /absolute/path/to/isolated/merged-compiler
BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES=-DBUSTER_LANE_WAIT_DIAGNOSTIC=1 ./build.sh --config Release
./build/compiler test-lanes --rounds 10
```

On the shared local machine use the `cores` queue separately for each build or test. For any future separately coordinated Benchpress diagnostic, first qualify the exact merged compiler, follow its host policy and acquire the shared lock per run. Build and identify the timing compiler separately, without this instrumentation patch or definition. With `BUSTER_WAIT_TRACE=1`, `--lanes N --lane-cpus LIST` and `--time-stages`, verify the per-lane pin receipts and diagnostic CPU identities before interpreting records.

Each pinned **session lane** records thread-local class/outcome counts and inclusive clocked intervals around initial PAUSE spins, MWAITX calls, fallback spins, barrier futex and other futex calls, including interrupted or failed calls. Per-lane calibration measures 1,000 consecutive clock-read pairs. These are perturbed wall intervals, including clock/loop overhead, interrupts and scheduling; they do not establish wake reason, hardware C-state residence, frequency effect, or an uninstrumented waiting-time distribution. Concurrent lanes' intervals cannot be summed as process wall time. The diagnostic forces workers to join before reporting, so later production terminal parking is excluded. Cold `lane_run` threads, separate `lane_team` workers and other helper/library threads are outside the scope. See the [original prototype's methodology](../wait-diagnostic-prototype-2026-11-06/README.md) for class definitions and histogram boundaries.

## Validating wait records

[`validate-wait.py`](validate-wait.py) checks complete diagnostic stderr for one separately monitored process with one through eight explicitly requested CPUs, a launcher-captured compiler PID, and a successful exit-status receipt. It requires exact pin and lane records, owner PID, distinct positive thread IDs, complete unique class/outcome rows, no clock failures, consistent histogram bucket bounds and totals, and all calibrations. It refuses malformed, missing, duplicate or unexpected diagnostic records. If independent ordered worker-TID receipts exist, `--tids` compares them; without those receipts, only lane 0's PID and uniqueness of the workers are independently checkable.

```sh
python3 validate-wait.py --cpus 0,1,2,3 --pid "$compiler_pid" --status-file diagnostic.status diagnostic.stderr
python3 test_validate_wait.py -v
```

The CPU list, PID and exit status must come from a trusted launcher for the same process. The validator does not prove their provenance, host lock ownership, compiler/input identities or output-object equality; those remain separate fail-closed checks before using observations. It does not validate arbitrary nondiagnostic stderr. The 1–10 ms histogram bucket straddles 1.5 ms, so these perturbed intervals cannot give an exact count above that threshold. The local and hosted tests use synthetic malformed/missing/duplicate inputs and the retained four-lane equal-tree trace; they do not replace validation on the 9700X.

## Local equal-tree evidence

Before merge, separate instrumented and uninstrumented native Release builds and tests used PR #1528 head `ebe94b467ef415ed27df4cc89a8a0436a82040b1`, with tree `1829aa50f677d713bcb250966746575d526989ef`, on a Ryzen 9 7940HS. The auditor independently confirmed that this tree is identical to the merged commit's tree. Those binaries were built from the pre-merge commit, not from the merge commit; source-tree equality does not turn them into exact-commit native qualification. Both builds passed under separate local core grants. The diagnostic `test-lanes --rounds 10` passed, including actual futex wake, EAGAIN and EINTR, timer and accounting checks, and MWAITX where supported. A four-lane smoke reported four matching lane/CPU identities, 80 consistent class/outcome rows and four calibrations, and its object matched the one-lane control byte-for-byte (SHA-256 `e832b84ff5e99a5320d526ce630fa06f513f87d257ff7b772244e6e31b151f8a`). Instrumented and control compiler hashes were `6f978b7f4900c3644bff1d2ec1525488fd387987dcf2b851fb7a2ec293019ec4` and `2edfb782f09bfd0401c05539d0717be989d0fa8c72af4a0074b2002686c3962e` respectively.

[`local-equal-tree.tar.gz`](local-equal-tree.tar.gz) retains commands, source/input and binary hashes, build and test logs/statuses, raw diagnostic rows, CPU identities, validator and a file manifest. The compiler binaries and objects are not distributed, so object equality cannot be rechecked from the archive alone. Queue messages containing other sessions' holder details were replaced with an omission marker; original logs remain local. This is bounded local diagnostic validation, not a performance curve or native acceptance.

Agent: OpenAI Codex, model OpenAI GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-da73-7731-9bcf-4312e3561034`; no shareable session URL was exposed.
