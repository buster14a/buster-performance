#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
out=$root/digits8-diag;mkdir -p "$out"; until [[ -f results/digits8/.built ]];do sleep 2;done
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/oracle/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main;do
 key=${c}_arguments;eval "args=(${!key})"
 for arm in before on;do
  exe=$root/results/digits8/compiler;[[ $arm != before ]] || exe=$root/results/before/compiler
  p=$out/$c-$arm;st=0
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.stdout" 2>"$p.stderr"' _ "$p" env BUSTER_TEST_DECIMAL_EIGHT="$arm" BUSTER_TEST_DECIMAL_EIGHT_TWIN=1 "$exe" -fsyntax-only -Wall -Wextra "${args[@]}" >"$p.lock" 2>&1 || st=$?
  sed -E '/^decimal-twin:/d' "$p.stderr" >"$p.diag";echo "$st" >"$p.status"; if [[ $arm != before ]];then for x in diag stdout status;do cmp "$out/$c-before.$x" "$p.$x";done;fi
  echo "$c $arm" >> "$out/status"
 done
done
date -u +%FT%TZ >"$out/done"
