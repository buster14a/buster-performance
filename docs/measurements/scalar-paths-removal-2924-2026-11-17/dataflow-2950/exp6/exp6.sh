#!/bin/bash
# #2950, run 6: the production tree with the empty-row early return (2950-c.patch), and the same with both
# preparations on the IR's vector checks (2950-c-checks.patch), which isolates dataflow's own preparation arms:
# IR dataflow on sqlite3.c and edges.c. Release, under the lock, CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Dataflow #2950: run 6" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2950
L=~/buster-fast-bench/exclusive.sh
O=exp6
mkdir -p $O
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite_args=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for tree in c c-checks; do
    if [ ! -d t$tree-src ]; then git clone -q src t$tree-src || exit 1; fi
    git -C t$tree-src checkout -q --detach 8bd7f27ec && git -C t$tree-src reset -q --hard && git -C t$tree-src clean -qfd -e build && git -C t$tree-src apply "$D/2950-$tree.patch" || { echo "patch $tree failed" >> $O/status.txt; exit 1; }
    (cd t$tree-src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/$O/build-$tree.log" 2>&1) || { echo "build $tree failed" >> $O/status.txt; exit 1; }
    cp t$tree-src/build/compiler $O/compiler-$tree
done
for tree in c c-checks; do
    (cd t$tree-src && $L timeout -k 5 1500 taskset -c 2 "$D/$O/compiler-$tree" test-ir-source --dataflow-benchmark "${sqlite_args[@]}" > "$D/$O/ir-sqlite-$tree.log" 2>&1)
    echo "ir sqlite $tree: $?" >> $O/status.txt
    (cd t$tree-src && $L timeout -k 5 600 taskset -c 2 "$D/$O/compiler-$tree" test-ir-source --dataflow-benchmark tests/dataflow/edges.c > "$D/$O/ir-edges-$tree.log" 2>&1)
    echo "ir edges $tree: $?" >> $O/status.txt
    xz -9 -T2 "$D/$O/ir-sqlite-$tree.log"
done
date -u +%FT%TZ > $O/.done
