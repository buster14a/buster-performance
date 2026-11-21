#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
out=$root/location-safe-diag;mkdir -p "$out"; until [[ -f results/locsafe/.built ]];do sleep 2;done
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main;do
 key=${c}_arguments;eval "args=(${!key})"
 for arm in before restore poison;do
  exe=$root/results/locsafe/compiler;[[ $arm != before ]] || exe=$root/results/before/compiler
  p=$out/$c-$arm;st=0
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.stdout" 2>"$p.stderr"' _ "$p" env BUSTER_TEST_PP_FILE_LOCATIONS="$arm" "$exe" -fsyntax-only -Wall -Wextra "${args[@]}" >"$p.lock" 2>&1 || st=$?
  echo "$st" >"$p.status"; if [[ $arm != before ]];then for x in stderr stdout status;do cmp "$out/$c-before.$x" "$p.$x";done;fi
  echo "$c $arm" >> "$out/status"
 done
done
date -u +%FT%TZ >"$out/done"
