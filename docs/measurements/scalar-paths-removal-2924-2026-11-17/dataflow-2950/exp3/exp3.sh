#!/bin/bash
# #2950, experiment 3: IR dataflow on sqlite3.c and edges.c with each candidate: the solver's branch bypass, the
# operands' locality by offset range (no gather), the lighter set, and all three. Release, under the lock, CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Dataflow #2950: the solver's class-2 experiment 3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2950
L=~/buster-fast-bench/exclusive.sh
O=exp3
mkdir -p $O
if [ ! -d exp3-src ]; then git clone -q src exp3-src || exit 1; fi
git -C exp3-src checkout -q --detach 8bd7f27ec && git -C exp3-src reset -q --hard && git -C exp3-src clean -qfd -e build && git -C exp3-src apply "$D/c3x-full3.patch" || { echo "patch failed" > $O/status.txt; exit 1; }
(cd exp3-src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/$O/build.log" 2>&1) || { echo "build failed" >> $O/status.txt; exit 1; }
cp exp3-src/build/compiler $O/compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
for variant in default bypass range set all; do
    case $variant in
        default) env="BUSTER_DF_NONE=1" ;;
        bypass) env="BUSTER_DF_BYPASS=1" ;;
        range) env="BUSTER_DF_RANGE=1" ;;
        set) env="BUSTER_DF_SET=1" ;;
        all) env="BUSTER_DF_BYPASS=1 BUSTER_DF_RANGE=1 BUSTER_DF_SET=1" ;;
    esac
    (cd exp3-src && $L timeout -k 5 1500 env $env taskset -c 2 "$D/$O/compiler" test-ir-source --dataflow-benchmark --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > "$D/$O/ir-sqlite-$variant.log" 2>&1)
    echo "ir sqlite $variant: $?" >> $O/status.txt
    (cd exp3-src && $L timeout -k 5 600 env $env taskset -c 2 "$D/$O/compiler" test-ir-source --dataflow-benchmark tests/dataflow/edges.c > "$D/$O/ir-edges-$variant.log" 2>&1)
    echo "ir edges $variant: $?" >> $O/status.txt
    xz -9 -T2 "$D/$O/ir-sqlite-$variant.log"
done
date -u +%FT%TZ > $O/.done
