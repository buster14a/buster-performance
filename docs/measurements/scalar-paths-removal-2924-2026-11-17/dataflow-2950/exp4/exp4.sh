#!/bin/bash
# #2950, run 4: the production tree (the solver's branch bypass, the operands' range test, the lighter set; scalar
# twins kept) against its own twins: benchmark-dataflow and IR dataflow on sqlite3.c and edges.c; then the
# experiment build's "all" knobs with BUSTER_DF_CHECKS, which gives the scalar preparation the IR's vector checks too.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Dataflow #2950: the production tree's measurement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2950
L=~/buster-fast-bench/exclusive.sh
O=exp4
mkdir -p $O
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite_args=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for tree in prod exp4x; do
    if [ ! -d $tree-src ]; then git clone -q src $tree-src || exit 1; fi
    patch=$D/2950-a.patch; [ $tree = exp4x ] && patch=$D/c3x-full4.patch
    git -C $tree-src checkout -q --detach 8bd7f27ec && git -C $tree-src reset -q --hard && git -C $tree-src clean -qfd -e build && git -C $tree-src apply "$patch" || { echo "patch $tree failed" >> $O/status.txt; exit 1; }
    (cd $tree-src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/$O/build-$tree.log" 2>&1) || { echo "build $tree failed" >> $O/status.txt; exit 1; }
    cp $tree-src/build/compiler $O/compiler-$tree
done
for round in 1 2 3; do
    $L timeout -k 5 900 taskset -c 2 $O/compiler-prod benchmark-dataflow > $O/bench-prod-$round.log 2>&1
    echo "bench prod $round: $?" >> $O/status.txt
done
(cd prod-src && $L timeout -k 5 1500 taskset -c 2 "$D/$O/compiler-prod" test-ir-source --dataflow-benchmark "${sqlite_args[@]}" > "$D/$O/ir-sqlite-prod.log" 2>&1)
echo "ir sqlite prod: $?" >> $O/status.txt
(cd prod-src && $L timeout -k 5 600 taskset -c 2 "$D/$O/compiler-prod" test-ir-source --dataflow-benchmark tests/dataflow/edges.c > "$D/$O/ir-edges-prod.log" 2>&1)
echo "ir edges prod: $?" >> $O/status.txt
xz -9 -T2 "$D/$O/ir-sqlite-prod.log"
env="BUSTER_DF_BYPASS=1 BUSTER_DF_RANGE=1 BUSTER_DF_SET=1 BUSTER_DF_CHECKS=1"
(cd exp4x-src && $L timeout -k 5 1500 env $env taskset -c 2 "$D/$O/compiler-exp4x" test-ir-source --dataflow-benchmark "${sqlite_args[@]}" > "$D/$O/ir-sqlite-all-checks.log" 2>&1)
echo "ir sqlite all-checks: $?" >> $O/status.txt
xz -9 -T2 "$D/$O/ir-sqlite-all-checks.log"
date -u +%FT%TZ > $O/.done
