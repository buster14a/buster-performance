# Frozen-input binding remedy: preparation, with no new execution

This is an unbuilt, unexecuted controller and a bounded plan for the remaining
[#893](https://github.com/buster14a/buster/issues/893) frozen-SQLite predicate.
It records no new verification, measurement, source qualification or acceptance.
The coordinating reviewer must independently review the exact additive commit
and resource plan before authorizing staging or execution. No further user
confirmation is requested by this preparation.

The distinct preparation claims are
[#893 comment6528493597](https://github.com/buster14a/buster/issues/893#issuecomment-6528493597)
and [#914 comment6528494129](https://github.com/buster14a/buster/pull/914#issuecomment-6528494129).
The former execution owner released the scope in6526646636; the separate146
editorial claim completed and released in6527876390. Re-read both threads before
any later action. Stop this remedy if an authentic contemporaneous receipt or
competing owner repair appears, and coordinate rather than overlap it.

## Exact scope and preserved history

Reuse the two ordinary, unmodified executables already reviewed in146:

| Arm | Source | Executable SHA256 |
| --- | --- | --- |
| base | d12fd5831f9c73bb7b30505da2ce9616e915143e | e0bbf2ced14fc4bb38c2073887b0fac5f8bf694789f8c9d71b726db8f292f7bf |
| head | 58b1191558fbef0b542cbe92b1e2da329f16d7b6 | 67d5039a94d367f1d8f9b61ace82fb0b9b0ad699d5360bb4979367c247d85c75 |

The conditional minimum is **one matched pair**, base then head,30 fresh
successful compiler processes per arm. It is not a promise that60 processes
will establish the final inference. Review sample counts, loss, attribution,
uncertainty and the actual new work boundary before deciding acceptance. A
failed or insufficient attempt is retained and stops the plan; no automatic
retry, added repetition matrix or favorable-result selection is authorized.

No compiler implementation or Buster rebuild,220-unit rerun,A/A campaign,
placement sweep, full sanitizer matrix, temporary workflow or CI dispatch is
included. Historical146's199 packet files, manifests, seven release assets/tag,
old results/rejected attempts,140 and the additive21664f reporting note remain
byte-for-byte intact. New verification cannot bind any old capture. This plan
does not measure current main or the prospective source merge.

## Before staging: independent review and ordinary source gates

1. Review this exact C source, its full additive diff, expected identities and
   the lock/core/timeout plan. It deliberately invokes no shell command text.
   This preparation has not compiled or run it, including its verification or
   child modes. No syntax/build/test success is claimed.
2. Recheck the applicable ordinary hosted source checks and source provenance
   for the intended pair before hardware use. Candidate58b's already recorded
   normal run41071125153 includes both hosted correctness configurations and
   native-vector qualification; independently authenticate its exact scope.
   A stale or missing required check is not green. Do not replace ordinary
   hosted prerequisites with a manual hardware run or a broad dispatch.
3. In a subsequently authorized ordinary hosted build, compile the reviewed
   controller (not Buster) with the official Clang23.1.4:

   ```sh
   clang -std=c17 -O2 -Wall -Wextra -Werror profile914.c -o profile914
   sha256sum profile914.c profile914
   ```

   Retain the full command, source commit/tree and source bytes, compiler/tool
   identity, stdout/stderr and genuine status. Independent review must bind the
   resulting executable to this exact source before it is staged. Its SHA is
   **unknown now**; `APPROVED_WRAPPER_SHA256` below is an unfilled execution gate,
   not an invented identity. This compilation is not authorized by preparation.

## New private snapshot, during a later authorized staging step only

Create a unique root, mode0700, named
`/home/david/buster-fast-bench/codex-pr914-input-binding-<unique-attempt>`.
It must not exist beforehand. Never overwrite the historical producer root,
shared `/var/lib` corpus, any old receipt or any prior attempt. Preserve failed
attempts in their own roots.

The future layout is:

```text
ROOT/
  dependencies/preprocessor-391e729af658-ci.tar.zst
  bin/base/compiler
  bin/head/compiler
  tools/profile914
  tools/attribution914
  tools/reuse_exec.so
  inputs/headers/                         full header bundle, not just usr/
  inputs/sqlite/                          complete sqlite manifest scope
  inputs/provenance/gnu17-pinned-predefines.txt
  inputs/manifests/headers-bundle.sha256
  inputs/manifests/sqlite.sha256
  results/                               new, initially absent
```

Obtain the pinned corpus archive from the same immutable release URL as current
`tools/ci/fetch-corpus.sh`:

```text
https://github.com/buster14a/buster-performance/releases/download/ci-corpora-preprocessor-391e729af658/preprocessor-391e729af658-ci.tar.zst
archive SHA256 ceb39bf938cd7a7469bbb53646c3318d0cbfdac4d37b6d05b183c4fd0b9898c2
```

Verify the actual downloaded archive before extraction. Extract only into a new
private scratch directory, record the command/status and root archive hash, and
copy the listed data into `ROOT/inputs` as ordinary independent files. Do not
use symlinks or hardlinks back to shared corpus files. A normal recursive copy
without `--preserve=links` can break archive-internal hardlinks. Retain component
notices and the archive privately; it need not be duplicated into Git. Make
the entire consumed snapshot, files and directories, nonwritable. Keep all
manifests alongside it. The controller rejects symlinks, hardlinked files,
writable nodes, special files, unexpected header/SQLite file counts and unsafe
manifest paths. It actually hashes every manifest-listed consumed header and
SQLite file before and after **each** arm, not merely the manifest.

The explicit consumed predefines hash is
`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`;
SQLite is
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
These are expected pinned facts, not verification receipts. They come from the
frozen manifest provenance, not from a newly hashed old producer pathname.
The header-bundle and SQLite manifest hashes are enforced in the controller.
All actual include/predefines/source paths passed to the compilers point to
this private snapshot. `-nostdinc` and the three explicit bundled include roots
are retained. Record actual before/after verification in the new arm receipt.

Copy the two original compiler bytes and reviewed offline reader/adapter into
the new layout without modifying them. Verify every expected hash in
`DEPENDENCIES.tsv` before accepting the staged layout. Record actual executable
and runtime dependency resolution from ELF metadata, preserving the original
loader/libc and reader libdw/libelf identities. If dependencies differ or cannot
be identified, stop for review rather than rebuild or silently substitute.
The controller checks known identities before/after and records matching actual
hashes of system taskset,sha256sum,timeout and the existing exclusive wrapper.
Those extra system-tool identities are unknown in this preparation, not claimed
to be frozen146 inputs. The root should read/freeze them for execution review.

No command above has been run by this preparation. Staging itself needs the
coordinating root's later bounded go-ahead and a fair, per-command resource plan;
it must not mutate the shared corpus, host packages, services or settings.

## Resource and lock contract

Use the current host README and current BusterAGENTS sharing rules, not old CI
priority behavior. Every arm takes the existing host lock separately, with:

```text
EXCLUSIVE_OWNER=codex-reviewer-914-input-binding
EXCLUSIVE_TITLE=#914 frozen-input paired profile, arm base|head
EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/893#issuecomment-6528493597
```

Never hold it across both arms or a series of runs. CI/other owners keep equal
priority. Do not kill a holder, modify the lock, use a reserved core, alter a
governor/perf limit, or change runner/system settings. Re-read current owner and
reservations before requesting a run. No lock/core grant was acquired here.

Where `cores` is actually on PATH, the applicable useful-work grant is two
physical cores for the compilerCPU2 and recorderCPU3. Read its actual help/status
and coordinate the documented acquisition order with the existing CI lock hooks
before proceeding: do not hold a core grant while waiting on a lock whose owner
is waiting for those cores, or hold the host lock while waiting on another
holder's grant. If the documented mechanism cannot provide both CPU2/3 without
leaving the grant, stop and have the coordinating root review a viable resource
plan. No cores option or priority exception is invented here. The earlier
noninteractive target `cores help` returned127; this is not a universal absence
claim. If it is absent in the actual reviewed execution environment, retain that
read-only receipt and use the normal host lock. The controller requires both
CPU2 andCPU3 in its inherited allowed mask before narrowing; it never treats an
unavailable CPU as permission to escape a grant.

The reviewed per-arm command shape, conditional on those resource checks and
the root's later go-ahead, is:

```sh
EXCLUSIVE_OWNER=codex-reviewer-914-input-binding \
EXCLUSIVE_TITLE='#914 frozen-input paired profile, arm base' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/893#issuecomment-6528493597 \
  /home/david/buster-fast-bench/exclusive.sh \
  /usr/bin/timeout --signal=TERM --kill-after=5s 470s \
  ROOT/tools/profile914 --arm base ROOT APPROVED_WRAPPER_SHA256
```

Release the lock/grant completely, inspect collection status and retain all
outputs, then separately invoke the same command with title/arm`head`.
The timeout is inside the lock, includes verification/recording/postchecks and
is not `--foreground`: its process group covers recorder and descendants. Even
the five-second kill grace stays below eight minutes. Timeout/nonzero/incomplete
postcheck stops the pair; keep partial files and no collection acceptance.
No automatic retry, stale-result overwrite or shared lock hold is provided.

## Fixed new capture protocol and actual records

`profile914 --arm` checks known tool/compiler/runtime identities, the private
snapshot, allowed CPUs and the existing held-lock environment. It records exact
perf argv, source identity, root, actual tool hashes, UTC boundaries, compiler
PIDs/statuses, output and raw-capture hashes. The candidate arm requires the base
collection marker; neither arm's existing result directory can be overwritten.

Recording invokes the existing pinned perf with:

```text
taskset -c 3 perf record -m 1M --no-buildid-cache -T -e cycles:u -c 250003
  --call-graph dwarf,4096 --sample-cpu --period -o NEW_CAPTURE
  -- ROOT/tools/profile914 --compile30 base|head ROOT
```

Every recorded process gets exactly this environment:
`HOME=/home/david`, `PATH=/usr/bin:/bin`, `LC_ALL=C`, `LANG=C`.
No inherited BASH_ENV,session variable,preload,tunable or credential environment
enters recorder or compiler startup. The C launcher forks30 fresh compiler
children, pins each toCPU2 within the parent's already checked grant, and logs
all30 actual child statuses. Compiler argv is retained separately. The C
launcher replaces the old Bash/taskset loop in both new arms; it does not claim
identical old capture timing. It writes the same arm-local object pathname on
each compile, matching the original protocol's output reuse. Only new paired
attribution is compared; do not combine new counts with old profile counts.

Before and after each arm the archive, actual consumed header/SQLite bytes and
explicit predefines are checked against immutable expected identities. Known
compiler/perf/reader/runtime identities must match; all recorded system-tool
hashes must remain unchanged. Matched inputs and tool identities across the
two arms are mandatory. A successful collection is labeled
`COMPLETE_PENDING_OFFLINE_GATES`, never performance acceptance.

## Offline analysis and acceptance, after separately authorized collection

Transfer new raw captures/receipts read-only; retain SHA256 before/after transfer
and all failed/rejected material. Independently verify the original compiler
ELF, runtime,perf,libdw/libelf,attribution-reader and adapter identities before
analysis. Construct a fresh symfs mapping for the actual new recorded compiler
paths/build IDs; no modified decoder copy may execute as a compiler.
Use the already reviewed single-profile decoder contracts, not its old hardcoded
six-profile grid paths:

```text
perf script -G --no-inline --comms compiler
  -F comm,pid,tid,period,event,ip,sym,dso --symfs NEW_SYMFS -i NEW_CAPTURE
LD_PRELOAD=PINNED_REUSE_EXEC_SO perf script --no-inline --comms compiler
  -F comm,pid,tid,period,event,ip,sym,dso --symfs NEW_SYMFS -i NEW_CAPTURE
PINNED_ATTRIBUTION914 NEW_CAPTURE ORIGINAL_ARM_ELF MATCHING_LIBC_ELF
  PRIMARY_TEXT CHAINS_TEXT NEW_PROOF.csv > NEW_SUMMARY.json
```

Retain exact commands,actual statuses,all stderr, tool/runtime hashes and proof/
coverage sidecars. Require empty decoder/reader diagnostics,30 distinct sampled
compiler PID/TID pairs per arm, zero raw loss/throttle and raw/pretty consistency,
and all direct-family CFI/CFA/saved-return/call-site proofs plus libc
E8→PLT→GOT `memcmp` proofs. Keep unknown/empty/skid/other-callee coverage explicit.
No global symbol-name guess or whole-inclusive-counter claim is allowed. Compare
the two final objects byte-for-byte and preserve both hashes/status. Stop for
any loss, missing sample PID, failed CFI/caller proof, input/dependency change,
nonzero compile, incomplete verification or unmatched protocol. Do not rebuild
tools, silently loosen the reader or launch another collection automatically.

The minimum new pair may be statistically or operationally insufficient. Only
independent exact-result review can decide what the fresh bound-workload/caller
estimates establish. The already separately bound220-unit packet remains in its
original scope and is not rerun here. Source#914/#893 acceptance and normal
live head/reviews/threads/checks/rules/mergeability remain separate; no new result
retroactively verifies146's old workload paths.
