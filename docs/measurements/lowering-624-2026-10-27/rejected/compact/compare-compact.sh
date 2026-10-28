#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/issue624
mkdir -p samples-compact
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
clang -std=c17 -O2 -Wall -Wextra -Werror compare.c -o compare
printf "compiler_base=92c025e71856d13eb34247477c5294d2cead139e\ncompiler_head=e661c8797ae84f71de10b712dcde9b223c328d30\n"
sha256sum base/build/compiler compact/build/compiler
clang --version
lscpu
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sha256sum "$sqlite/sqlite3.c"
taskset -c 2 ./compare 21 "$PWD/base/build/compiler" "$PWD/compact/build/compiler" "$PWD/samples-compact" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c"
for variant in base-a base-b batch; do
    taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u,branch-misses:u -o "samples-compact/stat-$variant.txt" -- "samples-compact/compiler-$variant" --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "samples-compact/perf-$variant.o"
    cat "samples-compact/stat-$variant.txt"
done
cmp samples-compact/perf-base-a.o samples-compact/perf-base-b.o
cmp samples-compact/perf-base-a.o samples-compact/perf-batch.o
sha256sum samples-compact/base-a.o samples-compact/base-b.o samples-compact/batch.o samples-compact/scalar.o
objdump -d --disassemble=check_lower_drain compact/build/compiler > samples-compact/lower-drain.s
objdump -d --disassemble=check_lower_batch_prepare compact/build/compiler > samples-compact/batch-prepare.s
