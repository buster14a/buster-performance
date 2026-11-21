#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD
mkdir -p independent-runtime;cd independent-runtime
cat >probe.c <<'C'
struct Pair { int skip; int field; int end; };
int branches(const struct Pair *p, const int *a, int x, int y, int z) {
    int r=0;
    if ((x || y) && z) r+=1;
    if ((x && y) || z) r+=2;
    if (a[x] == y) r+=4;
    if (p->field == z) r+=8;
    if (a[x] != z && (x || y)) r+=16;
    return r;
}
C
cat >driver.c <<'C'
#include <stdio.h>
struct Pair { int skip; int field; int end; };
extern int branches(const struct Pair*,const int*,int,int,int);
int main(void) {
    struct Pair p={3,1,2};
    const int a[32]={2,1,0,1,2,0,1,2};
    unsigned long long value=0;
    for(int x=0;x<4;++x)for(int y=0;y<3;++y)for(int z=0;z<3;++z)
        value=value*65599u+(unsigned)branches(&p,a,x,y,z);
    printf("%llu\n",value);
    return 0;
}
C
ref=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
"$ref" probe.c driver.c -o reference;./reference >reference.answer
cc="$d/pointer-condition-compiler"
switches=(NODE_SOURCE_CONDITION_ONLY=1 NODE_SPLICE_REPORT=1 NODE_SPLICE_FRONT=1 NODE_SPLICE_ENABLE=1 NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1 NODE_CROSS_CHUNK=n NODE_CROSS_TYPE_VIEW=1 NODE_CROSS_INCREMENTAL=1 NODE_CROSS_ARG_EPOCH=1 NODE_CROSS_FAST_REQUEST=1 NODE_SOURCE_STRINGS=1 NODE_CROSS_UNINDEXED=1 NODE_SOURCE_CONDITION=1 NODE_SOURCE_CONDITION_ORIGINS=1 NODE_SOURCE_ORIGIN_PUBLISHERS=1 NODE_SOURCE_CONSUME_CONDITION=1 NODE_SOURCE_CONSUME_BRANCH=1 NODE_SOURCE_CONSUME_LABELS=1 NODE_SOURCE_LABELS=1 NODE_SOURCE_CONSUME_POINTER=1)
for pol in ordinary debug wall;do
 f=();[[ $pol != debug ]] || f=(-g);[[ $pol != wall ]] || f=(-Wall -Wextra)
 for cfg in base derive flip stride label;do
  envs=(env);if [[ $cfg != base ]];then envs+=("${switches[@]}");fi
  case $cfg in flip) envs+=(NODE_SOURCE_FLIP_SENSE=1);;stride) envs+=(NODE_SOURCE_STRIDE_FAULT=1);;label) envs+=(NODE_SOURCE_LABEL_FAULT=1);;esac
  k=$pol-$cfg
  if "${envs[@]}" "$cc" --lanes 1 -c "${f[@]}" probe.c -o "$k.o" >"$k.stdout" 2>"$k.err";then
   "$ref" driver.c "$k.o" -o "$k.run"; timeout 3s "./$k.run" >"$k.answer" && st=0 || st=$?
  else st=$?;fi
  echo "$st" >"$k.status"
  if [[ $cfg == base || $cfg == derive ]];then cmp "$k.answer" reference.answer;fi
 done
done
