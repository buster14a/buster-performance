#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD
out="$root/identity-checker";mkdir -p "$out";cd "$root/trees/identity"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/identity/build.log" | head -1)
for mode in attested semantic-diagnostics program-selection program-overloads embed-initializers requests;do
 for tag in before identitypoison;do
  cc="$root/results/$tag/compiler"; p="$out/$mode-$tag";st=0
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$p" "$cc" test-checker "--$mode" --clang "$clang" --seed 133 >"$p.lock" 2>&1 || st=$?
  echo "$st" > "$p.status"
 done
 cmp "$out/$mode-before.status" "$out/$mode-identitypoison.status"
 test "$(cat "$out/$mode-before.status")" = 0
 echo "$mode pass" >> "$out/status"
done
date -u +%FT%TZ > "$out/done"
