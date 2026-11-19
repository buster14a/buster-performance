#!/bin/bash
# #2924 C12b: what head's 0.7 more instructions a token in benchmark-parser's vector row are, and what -c of sqlite3.c's
# +0.5% is. Run's executables (compilers/base, compilers/head), every run under the lock on CPU 2:
# 1. benchmark-parser --only stages on main.c and sqlite3.c, base and head (each stage's instructions);
# 2. perf stat of -c sqlite3.c, ten runs a side, in ABBA order, from fresh copies.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the parser, C12b" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p probe copies
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
BP=(-march=znver5 -I"$D/src-base/src" -fwrapv -funsigned-char --predefines "$D/predefines.h" -DBUSTER_COMPLETE_DRIVER=1 "$D/src-base/src/buster/compiler/main.c")
for side in base head; do
    cp compilers/$side copies/$side-probe
    $L timeout -k 5 900 taskset -c 2 ./copies/$side-probe benchmark-parser --passes 5 --only stages "${BP[@]}" > probe/stages-$side-buster.log 2>&1; echo "stages $side buster: $?" >> probe/status.txt
    $L timeout -k 5 900 taskset -c 2 ./copies/$side-probe benchmark-parser --passes 5 --only stages "${S[@]}" > probe/stages-$side-sqlite.log 2>&1; echo "stages $side sqlite: $?" >> probe/status.txt
    $L timeout -k 5 900 taskset -c 2 ./copies/$side-probe benchmark-parser --passes 5 --only vector "${S[@]}" > probe/vector-$side-sqlite.log 2>&1; echo "vector $side sqlite: $?" >> probe/status.txt
    rm -f copies/$side-probe
done
out=/dev/shm/claude-2924-c12b-probe
for side in base head head base; do
    rm -rf "$out"; mkdir -p "$out"
    cp compilers/$side "$out/compiler"
    $L timeout -k 5 900 taskset -c 2 perf stat -r 10 -e cycles:u,instructions:u,iTLB-load-misses:u,L1-icache-load-misses:u,page-faults:u,branch-misses:u \
        "$out/compiler" -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" >> probe/perf-$side.log 2>&1; echo "perf $side: $?" >> probe/status.txt
done
rm -rf "$out"
echo done >> probe/status.txt
