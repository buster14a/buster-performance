#!/bin/bash
# #2950 class 2, experiment 2: the bypass as a branch (the load of the previous block's in row skipped, not blended),
# and the store-to-load counters for the mid-size workloads alone (BUSTER_DF_WORKLOAD). Release, under the lock, CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Dataflow #2950: the solver's class-2 experiment 2" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2950
L=~/buster-fast-bench/exclusive.sh
O=exp2
mkdir -p $O
if [ ! -d exp2-src ]; then git clone -q src exp2-src || exit 1; fi
git -C exp2-src checkout -q --detach 8bd7f27ec && git -C exp2-src reset -q --hard && git -C exp2-src clean -qfd -e build && git -C exp2-src apply "$D/c3x-full2.patch" || { echo "patch failed" > $O/status.txt; exit 1; }
(cd exp2-src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/$O/build.log" 2>&1) || { echo "build failed" >> $O/status.txt; exit 1; }
cp exp2-src/build/compiler $O/compiler
events=cycles,instructions,ls_stlf,ls_bad_status2.stli_other,ls_dispatch.ld_dispatch,ls_dispatch.store_dispatch
for workload in mid-sparse-nested mid-sparse-diamond small-diamond; do
    for variant in scalar avx512 avx512-bypass; do
        case $variant in
            scalar) only=scalar; env="BUSTER_DF_NONE=1" ;;
            avx512) only=avx512; env="BUSTER_DF_NONE=1" ;;
            avx512-bypass) only=avx512; env="BUSTER_DF_BYPASS=1" ;;
        esac
        $L timeout -k 5 600 env $env BUSTER_DF_WORKLOAD=$workload taskset -c 2 perf stat -x, -e $events -o $O/perf-$workload-$variant.csv $O/compiler benchmark-dataflow --only $only > $O/bench-$workload-$variant.log 2>&1
        echo "perf $workload $variant: $?" >> $O/status.txt
    done
done
for round in 1 2 3; do
    for bypass in 0 1; do
        if [ $bypass = 1 ]; then env="BUSTER_DF_BYPASS=1"; else env="BUSTER_DF_NONE=1"; fi
        $L timeout -k 5 900 env $env taskset -c 2 $O/compiler benchmark-dataflow > $O/bench-bypass$bypass-$round.log 2>&1
        echo "bench bypass=$bypass $round: $?" >> $O/status.txt
    done
done
date -u +%FT%TZ > $O/.done
