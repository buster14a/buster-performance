#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
source ./corpora.sh
modes=(factsoperands factsinputs factsnames factsarrows)
exp=results/step1-direct-inputs
mkdir -p "$exp"
for n in 1 2 3 4;do
 half=()
 for ((i=0;i<4;i++));do half+=("${modes[(n-1+i)%4]}");done
 order=("${half[@]}")
 for ((i=3;i>=0;i--));do order+=("${half[i]}");done
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
