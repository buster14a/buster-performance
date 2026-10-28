# Reproduction and method boundaries

Use the exact sources in README and `source.patch`; preserve the pinned SQLite
amalgamation, predefines, header snapshot and toolchain identities in the source/
header manifests and build traces in the archives. Ordinary current system
headers or a different Clang are not this frozen experiment.

All substantial target operations use a separate `exclusive.sh` grant, owner,
title and issue link, CPU affinity and an explicit timeout. The recorded build
bound is180s; cohorts120s. No settings are changed. Local multithreaded operations
use `cores -n 2`; long single-thread work uses `cores -n 1`.

1. `method/build-stage.sh` and the reviewed `build-capture.diff` retained in the
   archives show candidate build commands. The external `build-capture.sh` adds
   three statements after the ordinary link to preserve temporary objects before
   existing cleanup. It does not change flags, source or link order.
2. `method/run-stage.sh` preserves exact correctness, pinned SQLite arguments,
   Stage1 whole-process and reader commands. `method/time-command-counters.c`
   is the original exact-child wait4/perf receipt helper. Its `/bin/true` and
   `/bin/false` controls retain status propagation. It does not itself lock or pin.
3. `method/capture-baseline-stage2.sh` rebuilds baseline from the same original
   source directory and verifies the resulting ELF SHA equals the original.
   Original config/build receipts are archived before this operation.
4. Rejected `relink-*` methods and first hot zero controls are retained, with
   failed address/byte audits. Do not use them as equivalent controls or timings.
5. `hot-zero-*`, `normalize-x87-self-add.c`, `normalized-zero-*`,
   `elf-alloc-equal.c`, `pad-hot-assembly.c` and `hot-padding-*` preserve the final
   control method. Require every zero allocated byte/layout/header/symbol audit,
   then all requested hot symbol addresses, byte/runtime gates and hashes before
   timing. The normalization applies exactly once inside the named cold test;
   no production-source modification or other assembly patch is allowed.
6. `method/time-hot-placement.sh sql 1` (then sql2, sql3 and tiny1) preserves exact
   final commands and original order. It invokes the unchanged baseline's
   `time-runs --runs 3 --warmups 1 --copies 3 --directory /tmp`, six builds per
   role, roles base/head/base-again, `--lanes 1 -c`. It uses fresh regular copies
   and a reused output path. Do not silently extend/drop samples.
7. Compile `method/summarize-placements.c` with a C compiler and pass one raw
   `raw/layout/layout-*.log` path as its single argument. It validates162 unique measured slots,
   zero statuses, complete positive counters, no missing roles and the runner's
   completion. Its median convention is the average of the two middle values.

The local standalone sanitizer adapter calls only comma, prefix and repair
oracles. Its reused legacy generator is included as
`method/make-source-adapter-legacy.c`: it empties BUSTER_ELSEWHERE for standalone
linkage, redirects a checker-test include, and retains a historical *diagnostic
print classification* for the old selected-walk caption. It never changes
failure accounting or return status; these focused entrypoints do not reach that
source-family caption. The full native/generic compiler checker gates use
unaltered source. Generated adapter contents and original commands are in the
local text archive. Later reproduction should prefer only the needed linkage/
include adaptations rather than assuming the legacy diagnostic edit is required.

`method/make-page-adapter.c` observes actual production tree_only reader inputs;
its hook counts original/new logical write-page sets and compares every byte.
This is not an allocator/RSS causal measurement. The small `comma-source.c`
generator and retained generated fixtures are original. All source extracts
retain their project notices. Native ELF/object/assembly payloads remain in
private retention with exact hash/size inventories; they are not embedded here.
