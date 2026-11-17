#!/bin/bash
# #2924 phase C, dataflow's gate on the 9700X: main's Release build (8bd7f27ec), then each run under the lock pinned to
# CPU 2: benchmark-dataflow five processes each of --only scalar and --only avx512 (back to back, the guide's fair
# comparison) and three of the default interleaved run; and IR dataflow's scalar and vector solve and prepare-solve
# (test-ir-source --dataflow-benchmark) on tests/dataflow/edges.c and on sqlite3.c with the correctness manifest's options.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: dataflow's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs compilers
if [ ! -d src ]; then git clone -q https://github.com/buster14a/buster src || exit 1; fi
git -C src fetch -q origin main && git -C src checkout -q --detach 8bd7f27ec || exit 1
git -C src rev-parse HEAD > logs/commit.txt
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-main.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compilers/main
sha256sum compilers/main > logs/compilers.sha256
for round in 1 2 3 4 5; do
    for only in scalar avx512; do
        $L timeout -k 5 900 taskset -c 2 ./compilers/main benchmark-dataflow --only $only > logs/bench-$only-$round.log 2>&1
        echo "bench $only $round: $?" >> logs/status.txt
    done
done
for round in 1 2 3; do
    $L timeout -k 5 900 taskset -c 2 ./compilers/main benchmark-dataflow > logs/bench-both-$round.log 2>&1
    echo "bench both $round: $?" >> logs/status.txt
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
(cd src && $L timeout -k 5 900 taskset -c 2 ../compilers/main test-ir-source --dataflow-benchmark tests/dataflow/edges.c > "$D/logs/ir-edges.log" 2>&1)
echo "ir edges: $?" >> logs/status.txt
(cd src && $L timeout -k 5 1500 taskset -c 2 ../compilers/main test-ir-source --dataflow-benchmark --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > "$D/logs/ir-sqlite.log" 2>&1)
echo "ir sqlite: $?" >> logs/status.txt
date -u +%FT%TZ > logs/.done
