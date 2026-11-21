#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
top=$PWD
group=$1;m=$2;kind=$3;stem=$4;scratch=$5
source ./corpora.sh
main_arguments="-march=native -I$top/pooled-main-source/src -fwrapv -funsigned-char --predefines $top/proof-predefines.h $top/pooled-main-source/src/buster/compiler/main.c"
v=${group}_arguments
eval "args=(${!v})"
args=(--lanes 1 -c "${args[@]}")
if [[ $kind == pmu || $kind == wall ]]; then
 limit_file=$top/results/full-chain-1c3-$group/retain-pmu-round
 if [[ -f $limit_file ]]; then
  stamp=${stem##*/}; n=${stamp#*-}; n=${n%%-*}
  [[ $kind == pmu && $n -le $(cat "$limit_file") ]] || exit 75
 fi
fi
case $group in
 sqlite|main) size=1; args+=(-o "$scratch/unit.o");;
 lua) size=34;;
 musl) size=1336;;
 *) exit 2;;
esac
case $m in baseline) exe=$top/results/chainprbase6e9/compiler;; packed) exe=$top/results/chainprod1c3/compiler;; esac
unset BUSTER_CHAIN_PACKED BUSTER_CHAIN_LAZY BUSTER_CHAIN_POISON BUSTER_GRAPH_STORAGE BUSTER_GRAPH_CAP_OVERRIDE
cd "$scratch"
rm -f -- ./*.o
case $kind in
 stage) "$exe" --time-stages "${args[@]}" >"$stem.stdout" 2>"$stem.stderr";;
 policy) "$exe" -Wall -Wextra "${args[@]}" >"$stem.stdout" 2>"$stem.stderr";;
 preflight) "$exe" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr";;
 pmu) perf stat --no-big-num -x, -o "$stem.perf" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults,context-switches,cpu-migrations -- "$exe" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr";;
 wall) "$top/results/baked177/compiler" time-runs --runs 1 --warmups 1 --executable "$exe" --list "${args[@]}" > "$stem.wall" 2>"$stem.stderr";;
esac
python3 "$top/full-chain-manifest.py" "$stem.objects" "$size"
