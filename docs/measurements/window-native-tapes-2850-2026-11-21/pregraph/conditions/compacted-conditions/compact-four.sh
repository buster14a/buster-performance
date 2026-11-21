#!/bin/bash
set -eu
cd "$(dirname "$0")";d=$PWD
cd ../switch-inputs;source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
for g in fixture lua musl sqlite main;do
 if [[ $g == fixture ]];then args=("$d/independent-runtime/probe.c" "$d/condition-runtime/conditional.c");else v=${g}_arguments;eval "args=(${!v})";fi
 python3 "$d/compact-corpus.py" "$d/compact-corpus" "$d/read-condition.compiler" "$g" "${args[@]}"
done
