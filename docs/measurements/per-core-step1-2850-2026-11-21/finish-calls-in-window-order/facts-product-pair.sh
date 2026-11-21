#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
source ./corpora.sh
d=results/step1-product-calls
mkdir -p "$d"
for n in {1..5};do
 order=(factsmain0e1d factsproduct factsproduct factsmain0e1d)
 if ((n%2==0));then order=(factsproduct factsmain0e1d factsmain0e1d factsproduct);fi
 for corpus in sqlite lua musl;do
  key=${corpus}_arguments;eval "args=(${!key})"
  for version in whole lean;do
   flags=(--facts);[[ $version != lean ]] || flags=(--facts-lean)
   for pos in "${!order[@]}";do
    label=${order[pos]}
    ./lock.sh taskset -c 2 "results/$label/compiler" measure-node-machine --shadow "${flags[@]}" --passes 5 "${args[@]}" >"$d/$corpus-$version-$n-$pos-$label.txt" 2>&1
   done
  done
 done
done
