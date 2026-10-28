# #442 target recipe for root review

Prerequisites now met locally: frozen73b6 native build, cross400, all220 four-path
objects byte-identical, SQLite four-path hash1cafbadf..., frozen symbol gate354/354
with zero differences/failures, native/scalar ASan+UBSan guard67536 each, checker,
callgraph and source selector. Root reported official baseline QA pass.

No target command has run yet. This document is a reviewable execution recipe.

## Immutable identities and build

- Baseline source e7f89091648f68940b595aadd648841c1ffc3ec5, baseline binary
  06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e.
- Candidate source73b6ba60604ca3da7494375f2468b23ae7d4c258,
  whole tree4d5e133b43f24b44808bff0015fb5b5faf27d5b8.
- Existing toolchain prefix:
  /home/david/buster-fast-bench/unclaimed-perf-20261028/toolchain-clang2314/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
- Match native/debug1 explicitly; generated-code options remain frozen znver5
  for SQLite, independent of the compiler host's native build.

Use tailscale ssh david@benchpress. Stage only a local git archive of the exact
candidate plus original helpers/fixtures; extract in private issue442-73b6 under
the campaign root with exclusive.sh holding the lock. Verify a source manifest
under a separate bounded locked command. Do not create another baseline build.
All target operations, including staging, hashing and packaging, use
EXCLUSIVE_OWNER=codex-442, EXCLUSIVE_TITLE and EXCLUSIVE_LINK. Every command takes
one shared lock; no outer controller holds a lock across separately queued runs.
Each SSH remote-command argument and each bash -c body must be shell-quoted with
ordinary single-quote escaping (never JSON quoting).

The build body, executed inside its own shared lock, is:

```sh
set -eu
campaign=/home/david/buster-fast-bench/unclaimed-perf-20261028
toolchain=$campaign/toolchain-clang2314/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export PATH=$toolchain/bin:$PATH
export LD_LIBRARY_PATH=$toolchain/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export BUSTER_CLANG_RESOURCE_DIR=$toolchain/lib/clang/23
export BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=1
cd "$campaign/issue442-73b6/source"
taskset -c 0-7 ./build.sh
```

Expected build bound~90s; timeout120s. If unexpectedly longer, retain the failed
receipt and split/coordinate a fair retry rather than silently raising a bound.
Native helper builds are a separate locked run expected<5s. Record matching
versions, flags, host, affinity, compiler hashes and source manifest.

## Qualification before timings

Use separate locked CPU2 runs for native ABI cross400 (<10s), the guarded helper
(<3s), frozen354-symbol gate (<30s), c-testsuite220 (<15s) and scalar/vector
baseline/head object identity (<15s). Preserve exact stdout/stderr/exit status.
The local frozen corpus is Zig0.14.1-vendored musl1.2.5 with documented patches
and copy-only generated overlay, not pristine upstream musl. Verify current
target corpus manifest/config before choosing its exact maintained gate.

## Measurements and limitations

1. Isolated initializer: matching baseline/candidate helper builds using the
   same compiler/flags; capacity64,256,4096,65536, widths16/32/64, both char modes.
   CPU2, equal repetitions, unchanged checksums. Each row/queued sample<2s.
2. Complete post-checking path: existing benchmark-lowering-source, checking
   outside timing, all220 files,101 passes, at least four complete paired rounds.
   Use equal-length baseline/head/baseagain executable paths and a three-role
   nine-edge cyclic order containing all predecessor/current pairs, with untimed
   primer. Preserve file-wise medians, role/order, counts, failures and totals.
   Per invocation expected<2s. Same-output220 must be demonstrated; also report
   the four historical differing IDs00150/00182/00208/00216 separately. Within-tree
   selective/all is never labeled candidate/main. Local screens do not replace
   this target record.
3. Fresh processes: function-containing increment, char-return (both char modes),
   derived aggregate,220-file corpus batch and frozen SQLite. Object-only no-body
   fixture is a separate negative control (#629 skips initialization there).
   Use matched CPU2, lanes1, sequential role balancing, no dropped samples, exact
   output bytes. Record whole wall/user/system, RSS, minor/major faults, context
   switches/migrations and core counters when available. Each queued sample is
   bounded<90s; tiny repeated executions use a fixed count rather than a duration
   that silently changes the amount of work across roles. No cache flush or
   global host changes. New execs include rodata/page-fault cost; they do not imply
   every page was cold in the shared page cache. Keep this limit explicit.

Retain baseline drift, nonzero/unsupported counters and negative/failed samples.
No strong whole-process gain/neutrality claim from isolated cost or historical25ns.
No PR until the source's gates and target controls are complete. PR references
#442 as bounded builtin work, not blanket Fixes442 or demand scheduler delivery.
