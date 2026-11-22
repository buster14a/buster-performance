#!/bin/bash
set -eu
cd "$(dirname "$0")"; study=$PWD; cc=${CHAIN_COMPILER:-$study/compiler}; cd ../switch-inputs;source ../switch-local-args.sh
case "$1" in
 sqlite) eval "args=($sqlite_arguments)";;
 main) tree=$PWD/../pregraph-warning-study/compiler-source;args=(-march=native -I"$tree/src" -fwrapv -funsigned-char --predefines "$PWD/../proof-predefines.h" "$tree/src/buster/compiler/main.c");;
 probe) args=("$study/probe.c");;
esac
prefix="$1.${CHAIN_MODE:-ordinary}"
for arm in base chain;do
 opts=(); if [[ ${CHAIN_LEGACY:-0} == 1 ]];then opts=(--node-window); fi; ex=();if [[ $arm == chain ]];then ex=(BUSTER_CONTROL_MEMBER_OPERANDS=1 BUSTER_CHAIN_AUDIT=1);fi
 env "${ex[@]}" "$cc" "${opts[@]}" --lanes 1 -c "${args[@]}" -o "$study/$prefix.$arm.o" >"$study/$prefix.$arm.stdout" 2>"$study/$prefix.$arm.stderr"
done
cmp "$study/$prefix.base.o" "$study/$prefix.chain.o"
if [[ "$1" != probe ]];then cmp "$study/$prefix.chain.o" "$study/../source-typed-study/$1.o";fi
