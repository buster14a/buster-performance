#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
lock=../../2850-codex-step2/lock.sh; dumps=../../672-st-claude/scratch
for g in musl sqlite3;do
 for m in single codes codebits;do
  "$lock" clang -O3 -g -march=native -Wall -Wextra "-DLANES_BAKED=\"$PWD/baked-$g.h\"" -o "$m-$g" "tools/$m.c" >"$m-$g.build" 2>&1
 done
done
for g in musl sqlite3;do
 for cache in warm cold;do
  extra=();[[ $cache != cold ]] || extra=(--after-scalar 200)
  for n in 1 2 3;do
   case $n in
    1) modes=(single codes codebits codebits codes single);;
    2) modes=(codes codebits single single codebits codes);;
    3) modes=(codebits single codes codes single codebits);;
   esac
   j=0;for m in "${modes[@]}";do
    "$lock" taskset -c 2 "./$m-$g" "$dumps/$g.dump" --passes 7 --first-passes 2 "${extra[@]}" >"$g-$cache-$n-$j-$m.txt" 2>&1
    j=$((j+1))
   done
  done
 done
done
