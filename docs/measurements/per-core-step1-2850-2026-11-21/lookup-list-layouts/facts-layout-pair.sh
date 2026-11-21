#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
source ./corpora.sh
modes=(factsdispatch factsoperands factsgroups factsconflicts factshalf)
exp=results/step1-layouts
mkdir -p "$exp"
for n in 1 2 3 4 5;do
 half=()
 for ((i=0;i<5;i++));do half+=("${modes[(n-1+i)%5]}");done
 order=("${half[@]}")
 for ((i=4;i>=0;i--));do order+=("${half[i]}");done
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
