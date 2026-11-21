#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
root=$PWD
out=$root/independent-native-late
cc=$out/compiler
test -x "$cc"
export NODE_SOURCE_SELECT_MASKS=1 NODE_SOURCE_SELECT_VERIFY=1 NODE_SOURCE_LATE_ROWS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_PROOF_NO_FP=1 NODE_PROOF_NATIVE=1
cd "$root/switch-inputs"
source "$root/switch-local-args.sh"
tree="$root/pregraph-warning-study/compiler-source"
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $root/proof-predefines.h $tree/src/buster/compiler/main.c"
for p in wall everything; do
 opts=(-Wall -Wextra); [[ $p != everything ]] || opts=(-Weverything -Wno-c++-compat)
 for c in sqlite lua musl main; do
  var=${c}_arguments
  eval "args=(${!var})"
  st=0; "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${opts[@]}" "${args[@]}" >"$out/$c-$p.out" 2>"$out/$c-$p.err" || st=$?
  echo "$st" >"$out/$c-$p.status"
  test "$st" = "$(cat "$root/independent-native-policy/$c-$p.status")"
  diff <(grep '^probe-native ' "$out/$c-$p.out") <(grep '^probe-native ' "$root/independent-native-policy/$c-$p.out")
 done
done
for group in tests inline; do
 python3 "$root/pregraph-to-native-campaign.py" "$cc" "$root/qa3204-24c" "$root/pregraph-warning-study/$group-events.jsonl" "$out/$group.tsv"
 cmp "$out/$group.tsv" "$root/independent-native-policy/$group.tsv"
done
echo 0 >"$out/qa.status"
