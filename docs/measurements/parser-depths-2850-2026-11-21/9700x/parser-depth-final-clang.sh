#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-parser-depth-blocks"
root=$PWD
until test -f results/final/.built; do sleep 3; done
cc=$root/results/final/compiler
exe=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/final/build.log" | head -1)
mkdir -p clang-final
cd trees/before
"$root/lock.sh" taskset -c 2 "$exe" -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null >"$root/clang-final/predefines.h"
for check in snippets main; do
 args=()
 [[ $check != main ]] || args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/clang-final/predefines.h" src/buster/compiler/main.c)
 "$root/lock.sh" bash -c 'd=$1; shift; exec taskset -c 2 "$@" >"$d.out" 2>"$d.err"' _ "$root/clang-final/$check" "$cc" test-parser --clang "$exe" --seed 133 "${args[@]}" >"$root/clang-final/$check.lock" 2>&1
 echo "$check pass" >> "$root/clang-final/status"
done
date -u +%FT%TZ > "$root/clang-final/done"
