#!/bin/bash
set -eu
cd "$(dirname "$0")";d=$PWD
cc=$d/read-condition.compiler
out=$d/required-runtime;mkdir -p "$out";cd "$out"
cp "$d/independent-runtime/probe.c" "$d/independent-runtime/driver.c" .
source <(sed -n '/^switches=(/p' "$d/compact-conditions.sh")
ref=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
"$ref" probe.c driver.c -o reference && ./reference >reference.answer
for p in ordinary debug wall;do
 f=();[[ $p != debug ]] || f=(-g);[[ $p != wall ]] || f=(-Wall -Wextra)
 for m in plain source compact stride without-reader;do
  en=(env);if [[ $m != plain ]];then en+=("${switches[@]}");fi
  if [[ $m == compact || $m == stride || $m == without-reader ]];then en+=(NODE_SOURCE_COMPACT=1 NODE_SOURCE_COMPACT_REPORT=1 NODE_SOURCE_COMPACT_CONDITION=1 NODE_SOURCE_COMPACT_READ_CONDITION=1);fi
  if [[ $m == stride ]];then en+=(NODE_SOURCE_STRIDE_FAULT=1);fi
  if [[ $m == without-reader ]];then en+=(env -u NODE_SOURCE_CONSUME_CONDITION);fi
  k=$p-$m
  "${en[@]}" "$cc" --lanes 1 -c "${f[@]}" probe.c -o "$k.o" >"$k.stdout" 2>"$k.err" && st=0 || st=$?
  if [[ $st == 0 ]];then "$ref" "$k.o" driver.c -o "$k.run";"./$k.run" >"$k.answer";fi
  echo "$st" >"$k.status"
 done
done
