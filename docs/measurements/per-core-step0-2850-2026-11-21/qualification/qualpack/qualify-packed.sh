#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
lock=../../2850-codex-step2/lock.sh
dumps=../../672-st-claude/scratch
for g in musl sqlite3;do
 for m in qualdynamic qualpackedkey;do
  "$lock" clang -O3 -g -march=native -Wall -Wextra "-DLANES_BAKED=\"$PWD/baked-$g.h\"" -o "$m-$g" "tools/$m.c" >"$m-$g.build" 2>&1
 done
done
sha256sum tools/*.[ch] baked-*.h qual{dynamic,packedkey}-{musl,sqlite3} "$dumps"/{musl,sqlite3}.dump >files.sha256
export VERIFY_UNKNOWN_KEYS=1
for n in 1 2 3 4 5;do
 modes=(qualdynamic qualpackedkey qualpackedkey qualdynamic)
 if ((n%2==0));then modes=(qualpackedkey qualdynamic qualdynamic qualpackedkey);fi
 for g in musl sqlite3;do
  for cache in warm cold;do
   extra=();[[ $cache != cold ]] || extra=(--after-scalar 200)
   j=0;for m in "${modes[@]}";do
    "$lock" taskset -c 2 "./$m-$g" "$dumps/$g.dump" --passes 21 --first-passes 5 "${extra[@]}" >"$g-$cache-$n-$j-$m.txt" 2>&1
    j=$((j+1))
   done
  done
 done
done
