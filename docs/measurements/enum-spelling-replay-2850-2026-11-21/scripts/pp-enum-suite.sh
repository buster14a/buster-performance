#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
base="$HOME/buster-fast-bench/2850-codex-step2/results/constbaseb86/compiler";cand="$root/results/enumdemand/compiler";until [[ -x $cand ]];do sleep 2;done
"$root/lock.sh" taskset -c 2 python3 "$root/pp-enum-tests.py" "$base" "$cand" "$root/enum-directed" > "$root/enum-directed.log" 2>&1
out=$root/enum-corpus;mkdir -p "$out"
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle/predefines.h src/buster/compiler/main.c"
for c in main lua sqlite musl;do
 key=${c}_arguments;eval "args=(${!key})"
 for warn in default wall;do
  flags=();[[ $warn == default ]] || flags=(-Wall -Wextra)
  for l in base cand;do exe=${!l};p="$out/$c-$warn-$l"; st=0
   "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$p" "$exe" -fsyntax-only "${flags[@]}" "${args[@]}" >"$p.lock" 2>&1 || st=$?
   echo "$st" >"$p.status"
  done
  for x in status out err;do cmp "$out/$c-$warn-base.$x" "$out/$c-$warn-cand.$x";done
  echo "$c $warn" >>"$out/status"
 done
done
date -u +%FT%TZ >"$out/done"
