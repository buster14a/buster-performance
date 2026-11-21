#!/bin/bash
set -eu
cd "$(dirname "$0")";d=$PWD;root=$d/..;cc=$d/view-vla-compiler
cd ../switch-inputs; source ../switch-local-args.sh
tree=$root/pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $root/proof-predefines.h $tree/src/buster/compiler/main.c"
export NODE_CROSS_CHUNK=b NODE_PROOF_NATIVE=1 NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_CROSS_TYPE_VIEW=1 NODE_CROSS_INCREMENTAL=1 NODE_CROSS_ARG_EPOCH=1 NODE_CROSS_FAST_REQUEST=1 NODE_SOURCE_STRINGS=1
for g in sqlite lua musl main;do
 v=${g}_arguments;eval "a=(${!v})"
 for policy in default wall all;do
  flags=();case $policy in wall) flags=(-Wall -Wextra);;all) flags=(-Weverything -Wno-c++-compat);;esac
  for mode in canonical private;do
   opts=(env -u NODE_CROSS_UNINDEXED)
   if [[ $mode == private ]];then opts+=(NODE_CROSS_UNINDEXED=1 NODE_CROSS_CHECK_INDEX=1);fi
   p=$d/reg-$g-$policy-$mode
   "${opts[@]}" "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${flags[@]}" "${a[@]}" >"$p.out" 2>"$p.err" && rc=0 || rc=$?
   echo "$rc" >"$p.status"
   grep -E '^(source-rows |cross-keys |cross-view |probe-full different-values|node-proof call-roots|node-proof stream roots)' "$p.err" >"$p.witness"
   grep '^probe-native ' "$p.out" >>"$p.witness"
   gzip -f "$p.err" "$p.out"
  done
  cmp "$d/reg-$g-$policy-canonical.witness" "$d/reg-$g-$policy-private.witness"
 done
done
