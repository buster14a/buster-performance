#!/bin/bash
# #2924 C12b: the benchmarks again, head2 (HEAD2 from c12b.bundle: the deletion with K6's block fallback out of line
# and benchmark-gnu's untimed first run of the collection and the build) against run.sh's base. benchmark-parser's
# stages and vector row on main.c and sqlite3.c, and benchmark-gnu, three rounds of base, head2 and base again, every
# run under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the parser, C12b" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
HEAD2=${HEAD2:?}
mkdir -p probe3 copies
git -C src-head fetch -q "$D/c12b.bundle" "+refs/heads/c12b:refs/heads/c12b" || { echo "bundle failed" >> probe3/status.txt; exit 1; }
git -C src-head checkout -q --detach "$HEAD2" && git -C src-head reset -q --hard
echo "head2 $(git -C src-head rev-parse HEAD)" > probe3/commits.txt
(cd src-head && $L timeout -k 5 1500 ./build.sh --config Release > "$D/probe3/build-head2.log" 2>&1) || { echo "build head2 failed" >> probe3/status.txt; exit 1; }
cp src-head/build/compiler compilers/head2
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
BP=(-march=znver5 -I"$D/src-base/src" -fwrapv -funsigned-char --predefines "$D/predefines.h" -DBUSTER_COMPLETE_DRIVER=1 "$D/src-base/src/buster/compiler/main.c")
run_copy() {
    local side=$1 log=$2
    shift 2
    cp compilers/$side copies/$side-run
    $L timeout -k 5 900 taskset -c 2 ./copies/$side-run "$@" > "$log" 2>&1
    local status=$?
    rm -f copies/$side-run
    return $status
}
for round in 1 2 3; do
    for pair in base:base head2:head2 base:base-again; do
        side=${pair%%:*}; name=${pair#*:}
        run_copy $side "probe3/stages-$round-$name-buster.log" benchmark-parser --passes 5 --only stages "${BP[@]}"; echo "stages $round $name buster: $?" >> probe3/status.txt
        run_copy $side "probe3/vector-$round-$name-buster.log" benchmark-parser --only vector "${BP[@]}"; echo "vector $round $name buster: $?" >> probe3/status.txt
        run_copy $side "probe3/vector-$round-$name-sqlite.log" benchmark-parser --only vector "${S[@]}"; echo "vector $round $name sqlite: $?" >> probe3/status.txt
        run_copy $side "probe3/gnu-$round-$name-sqlite.log" benchmark-gnu "${S[@]}"; echo "gnu $round $name sqlite: $?" >> probe3/status.txt
        run_copy $side "probe3/gnu-$round-$name-buster.log" benchmark-gnu "${BP[@]}"; echo "gnu $round $name buster: $?" >> probe3/status.txt
    done
done
echo done >> probe3/status.txt
