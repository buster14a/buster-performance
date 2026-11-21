#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD; cc=$PWD/condition-splice-compiler
cd condition-runtime;src=$PWD/conditional.c;driver=$PWD/driver.c
ref=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
"$ref" -O0 "$src" "$driver" -o clang.out
./clang.out >clang.answer
base=(NODE_SOURCE_CONDITION_ONLY=1 NODE_SPLICE_REPORT=1 NODE_SPLICE_FRONT=1 NODE_SPLICE_ENABLE=1 NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1 NODE_CROSS_CHUNK=n NODE_CROSS_TYPE_VIEW=1 NODE_CROSS_INCREMENTAL=1 NODE_CROSS_ARG_EPOCH=1 NODE_CROSS_FAST_REQUEST=1 NODE_SOURCE_STRINGS=1 NODE_CROSS_UNINDEXED=1 NODE_SOURCE_CONDITION=1 NODE_SOURCE_CONDITION_ORIGINS=1 NODE_SOURCE_CONSUME_CONDITION=1)
for pol in default wall debug;do
 f=();[[ $pol != wall ]] || f=(-Wall -Wextra);[[ $pol != debug ]] || f=(-g)
 for m in plain active;do
  envp=(env);[[ $m == plain ]] || envp+=("${base[@]}")
  p=$pol-$m
  "${envp[@]}" "$cc" --lanes 1 -c "${f[@]}" "$src" -o "$p.o" >"$p.stdout" 2>"$p.err"
  "$ref" "$driver" "$p.o" -o "$p.run";"./$p.run" >"$p.answer"
  cmp "$p.answer" clang.answer
 done
done
