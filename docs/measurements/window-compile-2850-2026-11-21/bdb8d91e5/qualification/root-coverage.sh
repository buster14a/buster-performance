#!/bin/bash
set -eu
cd "$(dirname "$0")";d=$PWD;cd ../switch-inputs;source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
for g in sqlite main;do
 v=${g}_arguments;eval "args=(${!v})"
 if [[ $g != lua ]];then args+=(-o "$d/coverage.o");fi
 (cd "$d" && gdb -q --batch -x root-coverage.gdb --args ../pending-native-windows/build/compiler --lanes 1 -c "${args[@]}") >"$d/coverage-$g.log" 2>&1
done
