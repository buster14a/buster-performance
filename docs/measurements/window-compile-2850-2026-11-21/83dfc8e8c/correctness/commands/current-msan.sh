#!/usr/bin/env bash
set -eu
d=$(cd "$(dirname "$0")" && pwd)
r="$d/83dfc8e8c/msan"
mkdir -p "$r"
cd "$d/../window-constants-msan"
clang=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
export PATH="$(dirname "$clang"):$PATH"
BUSTER_SANITIZER=memory BUSTER_SANITIZER_OPTIMIZATION=3 ./build.sh --config Release >"$r/build.log" 2>&1
cc="$PWD/build/compiler"
"$cc" --node-window-constants --time-stages --lanes 1 -g -c tests/checker/node-window-constants.c -o "$r/on.o" >"$r/on.out" 2>"$r/on.diag"
rg '^constant-window: roots=4 removed=10' "$r/on.diag"
"$cc" --lanes 1 -g -c tests/checker/node-window-constants.c -o "$r/off.o" >"$r/off.out" 2>"$r/off.diag"
cmp "$r/on.o" "$r/off.o"
"$cc" -DWINDOW_REMAPPED_SOURCE --poison-arenas --node-window-constants --time-stages --lanes 1 -g -c tests/checker/node-window-constants.c -o "$r/remapped.o" 2>"$r/remapped.diag"
rg '^constant-window: roots=4 removed=10' "$r/remapped.diag"
"$cc" -DWINDOW_REMAPPED_SOURCE --poison-arenas --lanes 1 -g -c tests/checker/node-window-constants.c -o "$r/remapped-ref.o" 2>"$r/remapped-off.diag"
cmp "$r/remapped.o" "$r/remapped-ref.o"
"$cc" test-checker --fixtures tests --clang "$clang" --seed 133 --part 5/8 > "$r/part5.log" 2>&1
rg 'checks, 0 failures' "$r/part5.log"
