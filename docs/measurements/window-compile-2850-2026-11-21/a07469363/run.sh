#!/bin/bash
set -eu
cd "$(dirname "$0")"
study=$PWD
cd ../switch-inputs
source ../switch-local-args.sh
case "$1" in
  sqlite) eval "args=($sqlite_arguments)" ;;
  main) tree=$PWD/../pregraph-warning-study/compiler-source;args=(-march=native -I"$tree/src" -fwrapv -funsigned-char --predefines "$PWD/../proof-predefines.h" "$tree/src/buster/compiler/main.c");;
esac
BUSTER_CONTROL_SOURCE_NATIVE=1 BUSTER_CONTROL_EARLY_NATIVE=1 BUSTER_CONTROL_EARLY_RELEASE=1 "$study/compiler" --lanes 1 -c "${args[@]}" -o "$study/$1.o"
cmp "$study/$1.o" "$study/../source-typed-study/$1.o"
