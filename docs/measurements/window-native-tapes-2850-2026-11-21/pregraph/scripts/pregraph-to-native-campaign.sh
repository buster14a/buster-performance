#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
base=$PWD
cc=$base/independent-native-values/compiler
out=$base/independent-native-policy
mkdir -p "$out"
cd switch-inputs
source "$base/switch-local-args.sh"
tree="$base/pregraph-warning-study/compiler-source"
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $base/proof-predefines.h $tree/src/buster/compiler/main.c"
export NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_PROOF_NATIVE=1 NODE_SOURCE_ROWS=1
for p in wall everything; do
 opts=(-Wall -Wextra); [[ $p != everything ]] || opts=(-Weverything -Wno-c++-compat)
 for c in sqlite lua musl main;do
  var=${c}_arguments
  eval "args=(${!var})"
  st=0; "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${opts[@]}" "${args[@]}" >"$out/$c-$p.out" 2>"$out/$c-$p.err" || st=$?
  echo "$st" >"$out/$c-$p.status"
 done
done
for group in tests inline;do
 python3 "$base/pregraph-to-native-campaign.py" "$cc" "$base/qa3204-24c" "$base/pregraph-warning-study/$group-events.jsonl" "$out/$group.tsv"
done
