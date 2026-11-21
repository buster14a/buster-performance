#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD
cc=$1;dir=$2;shift 2
cd ../switch-inputs;source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
for g in "$@";do
 case $g in fixture) files=("$d/condition-test.c" "$d/condition-runtime/conditional.c");;*) v=${g}_arguments;eval "files=(${!v})";;esac
 python3 "$d/physical-conditions.py" "$d/$dir" "$d/$cc" "$g" "${files[@]}"
done
