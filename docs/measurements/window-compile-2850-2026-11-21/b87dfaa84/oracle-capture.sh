#!/bin/bash
set -eu
cd "$(dirname "$0")";d=$PWD;cc=$d/compiler;cd ../switch-inputs;source ../switch-local-args.sh
for item in "$@";do
 case "$item" in probe)args=("$d/probe.c");; sqlite)eval "args=($sqlite_arguments)";; main) tree=$PWD/../pregraph-warning-study/compiler-source;args=(-march=native -I"$tree/src" -fwrapv -funsigned-char --predefines "$PWD/../proof-predefines.h" "$tree/src/buster/compiler/main.c");;esac
 for arm in base chain;do
   opts=();if [[ $arm == chain ]];then opts=(BUSTER_CONTROL_MEMBER_OPERANDS=1 BUSTER_CHAIN_POISON=1 BUSTER_CHAIN_AUDIT=1);fi
   pre="$d/$item.$arm";: >"$pre.typed";: >"$pre.graph";
   env "${opts[@]}" BUSTER_CHAIN_TYPED_FILE="$pre.typed" BUSTER_CHAIN_CHECKED_FILE="$pre.graph" "$cc" --lanes 1 -c "${args[@]}" -o "$pre.o" >"$pre.stdout" 2>"$pre.stderr"
 done
 cmp "$d/$item.base.typed" "$d/$item.chain.typed"
 cmp "$d/$item.base.o" "$d/$item.chain.o"
 python "$d/compare.py" "$item"
done
