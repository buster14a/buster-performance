#!/bin/bash
set -eu
cd "$(dirname "$0")"
d=$PWD
cd ../switch-inputs
source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
for g in "$@";do
 v=${g}_arguments
 eval "args=(${!v})"
 python3 "$d/run.py" "$g" "${args[@]}"
done
