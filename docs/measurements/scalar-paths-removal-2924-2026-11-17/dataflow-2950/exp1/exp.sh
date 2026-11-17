#!/bin/bash
# #2950 class 2: does the solver's loss at 33-128 blocks with <=64 values follow the path or the prepared copy, and
# does reading the previous block's in row from a register (BUSTER_DF_BYPASS) recover it? One Release executable of
# main 8bd7f27ec plus the oracle and the experiment knobs (c3x-full.patch); every run under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Dataflow #2950: the solver's class-2 experiment" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2950
L=~/buster-fast-bench/exclusive.sh
O=exp
mkdir -p $O
if [ ! -d exp-src ]; then git clone -q src exp-src || exit 1; fi
git -C exp-src checkout -q --detach 8bd7f27ec && git -C exp-src reset -q --hard && git -C exp-src clean -qfd -e build && git -C exp-src apply "$D/c3x-full.patch" || { echo "patch failed" > $O/status.txt; exit 1; }
(cd exp-src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/$O/build.log" 2>&1) || { echo "build failed" >> $O/status.txt; exit 1; }
cp exp-src/build/compiler $O/compiler
for round in 1 2 3; do
    for bypass in 0 1; do
        if [ $bypass = 1 ]; then env="BUSTER_DF_BYPASS=1"; else env="BUSTER_DF_NONE=1"; fi
        $L timeout -k 5 900 env $env taskset -c 2 $O/compiler benchmark-dataflow > $O/bench-bypass$bypass-$round.log 2>&1
        echo "bench bypass=$bypass $round: $?" >> $O/status.txt
    done
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
for variant in default same bypass same-bypass; do
    case $variant in
        default) env="BUSTER_DF_NONE=1" ;;
        same) env="BUSTER_DF_SAME_COPY=1" ;;
        bypass) env="BUSTER_DF_BYPASS=1" ;;
        same-bypass) env="BUSTER_DF_SAME_COPY=1 BUSTER_DF_BYPASS=1" ;;
    esac
    (cd exp-src && $L timeout -k 5 1500 env $env taskset -c 2 "$D/$O/compiler" test-ir-source --dataflow-benchmark --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > "$D/$O/ir-sqlite-$variant.log" 2>&1)
    echo "ir sqlite $variant: $?" >> $O/status.txt
    xz -9 -T2 "$D/$O/ir-sqlite-$variant.log"
done
date -u +%FT%TZ > $O/.done
