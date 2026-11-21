#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD; source ./corpora.sh
until [[ -e results/locsafe/.built ]];do sleep 2;done
out=$root/location-safe-check;mkdir -p "$out"; src=$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9
cd "$src"
for c in sqlite lua musl main;do
 case $c in
  sqlite) eval "args=($sqlite_arguments)";;lua) args=("$lua/lvm.c");;
  musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
  main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
 esac
 for op in print markers object wall;do
  opts=();case $op in print)opts=(-E -P);;markers)opts=(-E);;object)opts=(-c);;wall)opts=(-Wall -Wextra -c);;esac
  for mode in before record restore view poison;do
   cc=$root/results/locsafe/compiler; [[ $mode != before ]] || cc=$root/results/before/compiler
   p="$out/$c-$op-$mode"; st=0
   "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.stdout" 2>"$p.stderr"' _ "$p" env BUSTER_TEST_PP_FILE_LOCATIONS="$mode" "$cc" "${opts[@]}" -o "$p.result" "${args[@]}" >"$p.lock" 2>&1 || st=$?
   echo "$st" >"$p.status";(cd "$out" && sha256sum "$c-$op-$mode.result" "$c-$op-$mode.stderr" "$c-$op-$mode.stdout" >"$c-$op-$mode.sha")
   if [[ $mode != before ]];then for x in stdout stderr status result;do cmp "$out/$c-$op-before.$x" "$p.$x";done;rm "$p.result";fi
   echo "$c $op $mode" >>"$out/status"
  done
  rm "$out/$c-$op-before.result"
 done
done
date -u +%FT%TZ >"$out/done"
