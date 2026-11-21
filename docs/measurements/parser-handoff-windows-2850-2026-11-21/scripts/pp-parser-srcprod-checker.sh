#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD
out="$root/srcprod-checker";mkdir -p "$out";cd "$root/trees/srcprod"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/srcprod/build.log" | head -1)
for mode in attested semantic-diagnostics program-selection program-overloads embed-initializers requests;do
 for tag in base232 srcprod;do
  cc="$root/results/$tag/compiler"; p="$out/$mode-$tag";st=0
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$p" "$cc" test-checker "--$mode" --clang "$clang" --seed 133 >"$p.lock" 2>&1 || st=$?
  echo "$st" > "$p.status"
 done
 cmp "$out/$mode-base232.status" "$out/$mode-srcprod.status"
 test "$(cat "$out/$mode-base232.status")" = 0
 echo "$mode pass" >> "$out/status"
done
date -u +%FT%TZ > "$out/done"
