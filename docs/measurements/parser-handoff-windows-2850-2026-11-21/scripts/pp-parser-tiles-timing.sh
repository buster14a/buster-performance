#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
until [[ -f results/tiles/.built ]];do sleep 3;done
source ./corpora.sh
eval "args=($sqlite_arguments)"
mkdir -p tile-study
cd tile-study
out=$PWD
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
labels=(before 0 256 1024 4096 16384)
for round in {0..5};do
 flock -x 9
 for pos in {0..5};do
   k=$(((round+pos)%6));if ((round%2==1));then k=$((5-k));fi
   v=${labels[$k]};p="$out/$round-$pos-$v"
   exe="$root/results/tiles/compiler";width="$v";if [[ $v == before ]];then exe="$root/baseline/compiler";width=0;fi
   ln -sfn "$exe" cc
   for mode in tree tree-sizes;do
    "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$p-$mode" env BUSTER_HUGE_PAGES=1 BUSTER_TEST_PARSE_TREE_TILE="$width" "$out/cc" benchmark-parser --passes 7 --only "$mode" --repeat 3 "${args[@]}" >"$p-$mode.lock" 2>&1
   done
   "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.stages"' _ "$p" env BUSTER_HUGE_PAGES=1 BUSTER_TEST_PARSE_TREE_TILE="$width" "$out/cc" --time-stages -c -o "$out/sqlite.o" "${args[@]}" >"$p.driver.lock" 2>&1
   sha256sum sqlite.o | cut -d' ' -f1 >"$p.sha256";echo "$round $pos $v" >>status
 done
 flock -u 9
done
date -u +%FT%TZ >done
