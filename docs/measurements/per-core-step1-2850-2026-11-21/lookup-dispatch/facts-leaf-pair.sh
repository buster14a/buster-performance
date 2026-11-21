#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
source ./corpora.sh
modes=(main3257 factsdispatch factsleaf)
exp=results/step1-leaf-lines
mkdir -p "$exp"
for n in 1 2 3;do
 case $n in
  1) order=(main3257 factsdispatch factsleaf factsleaf factsdispatch main3257);;
  2) order=(factsdispatch factsleaf main3257 main3257 factsleaf factsdispatch);;
  3) order=(factsleaf main3257 factsdispatch factsdispatch main3257 factsleaf);;
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
