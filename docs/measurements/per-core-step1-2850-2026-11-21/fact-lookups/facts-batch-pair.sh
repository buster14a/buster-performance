#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
source ./corpora.sh
modes=(main3257 factsstride factsmember)
exp=results/step1-fact-batches
mkdir -p "$exp"
for n in 1 2 3;do
 case $n in
  1) order=(main3257 factsstride factsmember factsmember factsstride main3257);;
  2) order=(factsstride factsmember main3257 main3257 factsmember factsstride);;
  3) order=(factsmember main3257 factsstride factsstride main3257 factsmember);;
 esac
 for g in sqlite lua musl;do
  key=${g}_arguments;eval "args=(${!key})"
  for mode in whole lean;do
   flags=(--facts);[[ $mode != lean ]] || flags=(--facts-lean)
   j=0
   for m in "${order[@]}";do
    f=$exp/$g-$mode-$n-$j-$m.txt
    ./lock.sh taskset -c 2 "$PWD/results/$m/compiler" measure-node-machine --shadow "${flags[@]}" --passes 5 "${args[@]}" >"$f" 2>&1
    j=$((j+1))
   done
  done
 done
done
