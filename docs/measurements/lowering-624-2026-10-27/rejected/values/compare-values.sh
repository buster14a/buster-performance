#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/issue624
mkdir -p samples-values
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
clang -std=c17 -O2 -Wall -Wextra -Werror compare.c -o compare
printf "compiler_base=92c025e71856d13eb34247477c5294d2cead139e\ncompiler_head=552a543e34bf7c6be7ba642467e7b7b28d794bad\n"
sha256sum base/build/compiler values/build/compiler
clang --version
lscpu
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sha256sum "$sqlite/sqlite3.c"
taskset -c 2 ./compare 21 "$PWD/base/build/compiler" "$PWD/values/build/compiler" "$PWD/samples-values" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c"
for variant in base-a base-b batch; do
    taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u,branch-misses:u -o "samples-values/stat-$variant.txt" -- "samples-values/compiler-$variant" --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "samples-values/perf-$variant.o"
    cat "samples-values/stat-$variant.txt"
done
cmp samples-values/perf-base-a.o samples-values/perf-base-b.o
cmp samples-values/perf-base-a.o samples-values/perf-batch.o
sha256sum samples-values/base-a.o samples-values/base-b.o samples-values/batch.o samples-values/scalar.o
objdump -d --disassemble=check_lower_drain values/build/compiler > samples-values/lower-drain.s
objdump -d --disassemble=check_lower_batch_prepare values/build/compiler > samples-values/batch-prepare.s
