#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
top=$PWD
label=$1;group=$2;m=$3;kind=$4;stem=$5;scratch=$6
source ./corpora.sh
main_arguments="-march=native -I$top/pooled-main-source/src -fwrapv -funsigned-char --predefines $top/proof-predefines.h $top/pooled-main-source/src/buster/compiler/main.c"
v=${group}_arguments
eval "args=(${!v})"
if [[ $group == sqlite ]]; then args=(-c "${args[@]}"); else args=(--lanes 1 -c "${args[@]}"); fi
case $group in
 sqlite|main) size=1; args+=(-o "$scratch/unit.o");;
 lua) size=34;;
 musl) size=1336;;
 *) exit 2;;
esac
case $label in
 headmarks) parent=main3257 ;;
 expr74f|nodes39b|conversion59c|condition69e|cursorb6b|bind469) parent=main32588 ;;
 warnrootd2e|conda884) parent=main9be ;;
 *) parent=constbaseb86 ;;
esac
case "$m" in
 baseline) exe=$top/results/$parent/compiler ;;
 candidate) exe=$top/results/$label/compiler ;;
 *) exit 2 ;;
esac
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
