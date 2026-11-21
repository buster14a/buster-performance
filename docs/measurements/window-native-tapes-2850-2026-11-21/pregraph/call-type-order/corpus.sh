#!/bin/bash
set -eu
cd "$(dirname "$0")";d=$PWD;root=$d/..;cc=$root/call-first-effects/build/compiler
cd ../switch-inputs;source ../switch-local-args.sh
tree=$root/pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $root/proof-predefines.h $tree/src/buster/compiler/main.c"
for g in sqlite lua musl main;do
 p=${g}_arguments;eval "a=(${!p})"
 for pol in default wall;do
  opts=();[[ $pol != wall ]] || opts=(-Wall -Wextra)
  python3 "$d/corpus.py" "$cc" "$g-$pol" "$d/sparse-corpus" "${opts[@]}" "${a[@]}"
 done
done
