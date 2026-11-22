#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD;cd ../switch-inputs;source ../switch-local-args.sh
case $1 in sqlite) eval "args=($sqlite_arguments)";;
main) tree=$PWD/../pregraph-warning-study/compiler-source;args=(-march=native -I"$tree/src" -fwrapv -funsigned-char --predefines "$PWD/../proof-predefines.h" "$tree/src/buster/compiler/main.c");;esac
BUSTER_CONTROL_SOURCE_NATIVE=1 BUSTER_CONTROL_SOURCE_AUDIT=1 "$d/compiler" --lanes 1 -c "${args[@]}" -o "$d/$1.$2.o" > "$d/$1.$2.out" 2>"$d/$1.$2.stderr"
cmp "$d/$1.$2.o" "$d/../source-typed-study/$1.o"
