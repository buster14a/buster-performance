# Shared whole-process method

The original C `cohort.c` and `samples.c` are compiled with the host's ordinary
Clang (`-O2 -Wall -Wextra`). They execute real compilers and retain every child
status, affinity, wall time, CPU time, faults, peak RSS, context switches,
stderr and output. A one-job cohort is pinned to physical CPU 2; eight jobs use
physical CPUs 0–7, with one process per core. Every target invocation uses:

```sh
EXCLUSIVE_OWNER=OWNER EXCLUSIVE_TITLE=TITLE EXCLUSIVE_LINK=ISSUE_URL \
  ~/buster-fast-bench/exclusive.sh COMMAND ARGUMENTS...
```

The workspace on the target is
`~/buster-fast-bench/unclaimed-perf-20261028`. Its `corpus` symlink names the
unchanged, frozen `../microarch-20261027-exp/corpus`; measurements never modify
that shared input. SQLite source SHA-256 is
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`;
GNU17 predefines SHA-256 is
`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
The pinned header snapshot and external-source licenses are retained by that
existing corpus capsule; no external source is imported into this record.

Every ordinary SQLite `-c` cohort uses these exact arguments for both roles:

```sh
--lanes 1 -c
-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17
--predefines corpus/gnu17-pinned-predefines.txt --clang-features
--target=x86_64-linux-gnu -march=znver5 -nostdinc
-isystem corpus/headers/usr/lib/clang/23/include
-isystem corpus/headers/usr/local/include
-isystem corpus/headers/usr/include
-Icorpus/sqlite corpus/sqlite/sqlite3.c -o @OUTPUT@
```

The controller takes
`samples ROUNDS JOBS TASKS INPUT OUTPUT_ROOT COHORT BASE CANDIDATE FLAGS...`.
Roles alternate AB then BA on successive rounds. With two roles and one
workload this cycles through all four immediate-predecessor role pairs.
Different workloads are measured in separate invocations; mixing unrelated
loads in a cyclic slot rotation can confound previous-workload state.

For the initial current-main screen, use baseline
`./base-4165454e/build/compiler` and candidate
`./combined-416-b8cd163c/build/compiler`, at source commits `4165454e` and
`b8cd163c` respectively. The single-worker invocation uses 21 rounds, one job
and one task; the eight-worker invocation uses 11 rounds, eight jobs and 32
tasks. Each is a separate bounded lock hold. Repeat with the baseline in both
roles for A/A; preserve original record order and every fault/outlier.

Those initial screens use one image per source and are not acceptance of a
small general speedup. Placement/fresh-copy controls are required for such a
claim; issue 674 retains its separately verified balanced controller and actual
hot-section offsets. Physical copying an executable does not change its
code-section placement.

`current-b8-collect.sh` in the campaign work record verifies every emitted
object and collects metadata under the same target lock. Large raw objects stay
on the target and in local raw archives; digest manifests retain their exact
identities. Target compression, hashing and other substantial packaging also
take the lock, so they cannot perturb another accepted measurement.
