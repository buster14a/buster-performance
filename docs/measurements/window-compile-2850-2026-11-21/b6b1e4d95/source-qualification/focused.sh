#!/bin/bash
set -eu
d=$1; cc=$2; ref=$3
clang -c "$d/locals.c" -o "$d/clang.o"
clang "$d/driver.c" "$d/clang.o" -o "$d/clang"
"$d/clang" >"$d/expected"
for mode in plain scalar debug tier1 deferred all;do
 flags=(); case $mode in scalar) flags=(--scalar);; debug) flags=(-g);; tier1) flags=(--tier1);; deferred) flags=(--deferred-bodies --lanes 2 --worker-budget 2);; all) flags=(--lower-all);; esac
 for variant in base own; do
  exe=$cc;[[ $variant != base ]] || exe=$ref
  f=$d/$mode-$variant
  rm -f "$f.o"
  "$exe" --lanes 1 -nostdinc -c "${flags[@]}" "$d/locals.c" -o "$f.o" >"$f.out" 2>"$f.err"
  clang "$d/driver.c" "$f.o" -o "$f.exe"
  "$f.exe" >"$f.value";cmp "$d/expected" "$f.value"
 done
 cmp "$d/$mode-base.o" "$d/$mode-own.o";cmp "$d/$mode-base.err" "$d/$mode-own.err"
 nm "$d/$mode-own.o" >"$d/$mode.symbols"
done
