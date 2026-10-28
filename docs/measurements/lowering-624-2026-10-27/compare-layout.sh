#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# One placement, run through exclusive.sh. Invoke separately for every placement.
set -euo pipefail
cd /home/david/buster-fast-bench/issue624
placement=${1:?placement required}
samples="samples-layout-$placement"
if [ "$placement" = standard ]; then
    baseline="$PWD/base/build/compiler"
    candidate="$PWD/layout/build/compiler"
else
    baseline="$PWD/placements-base/compiler-$placement"
    candidate="$PWD/placements-layout/compiler-$placement"
fi
mkdir -p "$samples"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400 LC_ALL=C
clang -std=c17 -O2 -Wall -Wextra -Werror compare.c -o compare
printf 'compiler_base=92c025e71856d13eb34247477c5294d2cead139e\ncompiler_head=07df7873cde737d6bae914ff4eb81a75bf8c4f72\nplacement=%s\n' "$placement"
sha256sum "$baseline" "$candidate"
clang --version
lscpu
printf 'CPU 10 online: '
cat /sys/devices/system/cpu/cpu10/online
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sha256sum "$sqlite/sqlite3.c"
taskset -c 2 ./compare 21 "$baseline" "$candidate" "$PWD/$samples" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c"
for variant in base-a base-b batch; do
    taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u,branch-misses:u -o "$samples/stat-$variant.txt" -- "$samples/compiler-$variant" --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$samples/perf-$variant.o"
    cat "$samples/stat-$variant.txt"
done
cmp "$samples/perf-base-a.o" "$samples/perf-base-b.o"
cmp "$samples/perf-base-a.o" "$samples/perf-batch.o"
sha256sum "$samples/base-a.o" "$samples/base-b.o" "$samples/batch.o" "$samples/scalar.o"
objdump -d --disassemble=check_lower_drain "$candidate" > "$samples/lower-drain.s"
objdump -d --disassemble=check_lower_batch_classify "$candidate" > "$samples/batch-classify.s"

