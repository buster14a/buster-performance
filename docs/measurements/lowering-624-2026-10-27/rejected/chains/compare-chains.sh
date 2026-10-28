#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/issue624
mkdir -p samples-chains
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
clang -std=c17 -O2 -Wall -Wextra -Werror compare.c -o compare
printf "compiler_base=92c025e71856d13eb34247477c5294d2cead139e\ncompiler_head=21376d6e8e7339848dce91a0165e6ace8416e73b\n"
sha256sum base/build/compiler chains/build/compiler
clang --version
lscpu
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sha256sum "$sqlite/sqlite3.c"
taskset -c 2 ./compare 21 "$PWD/base/build/compiler" "$PWD/chains/build/compiler" "$PWD/samples-chains" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c"
for variant in base-a base-b batch; do
    taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u,branch-misses:u -o "samples-chains/stat-$variant.txt" -- "samples-chains/compiler-$variant" --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "samples-chains/perf-$variant.o"
    cat "samples-chains/stat-$variant.txt"
done
cmp samples-chains/perf-base-a.o samples-chains/perf-base-b.o
cmp samples-chains/perf-base-a.o samples-chains/perf-batch.o
sha256sum samples-chains/base-a.o samples-chains/base-b.o samples-chains/batch.o samples-chains/scalar.o
objdump -d --disassemble=check_lower_drain chains/build/compiler > samples-chains/lower-drain.s
objdump -d --disassemble=check_lower_batch_chain chains/build/compiler > samples-chains/batch-chain.s
