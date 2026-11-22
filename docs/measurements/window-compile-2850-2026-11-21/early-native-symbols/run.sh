#!/bin/bash
set -eu
cd "$(dirname "$0")"; d=$PWD
src=$d/../live-pp-forest/src
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
"$cc" -O1 -g1 -march=native -fwrapv -funsigned-char -std=gnu17 -I"$src" -I"$src/buster/compiler" live.c -o live >build.log 2>&1
cd ../switch-inputs; source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source;main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
for g in sqlite main; do
 v=${g}_arguments; eval "args=(${!v})"
 BUSTER_PREFIX_PATH="$d/$g" "$d/live" "${args[@]}" >"$d/$g.tsv" 2>"$d/$g.stderr" && rc=0 || rc=$?
 echo $rc >"$d/$g.status"
done
