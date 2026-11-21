#!/bin/bash
set -eu
cd "$(dirname "$0")";d=$PWD;cd ../main-fbef-clean
export PATH=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH
test -x build/compiler
base=$PWD/build/compiler;new=$PWD/../reader-typed-values/build/compiler
cd ../switch-inputs;source ../switch-local-args.sh;tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
out=$d/final-corpus;mkdir -p "$out"
for g in sqlite main lua musl;do v=${g}_arguments;eval "args=(${!v})";python3 "$d/../default-object-qa/pair.py" "$out" "$g" "$base" "$new" "${args[@]}";done
