#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;label=$1;cc=$root/results/$label/compiler
until [[ -f results/$label/.built ]];do sleep 2;done
out=$root/$label-focused;mkdir -p "$out";clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/$label/build.log"|head -1)
export PATH="$(dirname "$clang"):$PATH" BUSTER_CLANG_RESOURCE_DIR="$(dirname "$(dirname "$clang")")/lib/clang/23"
cd "$root/trees/$label"
for action in type-sugar-only operand-diagnostics-only;do
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$out/$action" "$cc" test-checker-driver --executable "$cc" --in-process "--$action" --clang "$clang" >"$out/$action.lock" 2>&1
 echo "$action" >>"$out/status"
done
for arm in clang candidate;do exe=$cc;[[ $arm != clang ]] || exe=$clang
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$out/$arm" "$exe" -fsyntax-only -fno-caret-diagnostics "$root/pp-enum-fixture.c" >"$out/$arm.lock" 2>&1
 grep ': warning:' "$out/$arm.err" >"$out/$arm.warnings";test "$(wc -l < "$out/$arm.warnings")" = 2
done
cmp "$out/clang.warnings" "$out/candidate.warnings";date -u +%FT%TZ >"$out/done"
