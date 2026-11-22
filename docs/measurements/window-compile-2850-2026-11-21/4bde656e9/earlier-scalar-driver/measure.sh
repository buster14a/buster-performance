#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"; d=$PWD; study=$1
cd ../switch-inputs; source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source;main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
for unit in sqlite main;do v=${unit}_arguments;eval "args=(${!v})";python3 "$d/measure.py" "$study" "$unit" "${args[@]}";done
