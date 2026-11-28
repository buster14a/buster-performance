#!/bin/bash
# lua-tests.sh COMPILER LUA_SRC TESTS OUT: Lua 5.4.8's units compiled with its Makefile's flags but -Wall -Wextra, by
# default (33 of 34 on the direct path) and with --no-direct, linked by clang into lua (luac.o left out) and each run on
# Lua's 5.4.8 test suite (lua-5.4.8-tests, sha256 9581d5a7...) in its portable mode: lua -e"_U=true" all.lua.
set -uo pipefail
B=$1; src=$2; tests=$3; out=$4; mkdir -p "$out"
for v in direct full; do
    mkdir -p "$out/o-$v"; opt=; [ $v = full ] && opt=--no-direct
    for f in "$src"/*.c; do "$B" $opt --lanes 1 -std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c "$f" -o "$out/o-$v/$(basename "$f" .c).o"; done
    echo "$v: $(for o in "$out"/o-$v/*.o; do readelf -p .comment "$o" | grep -q 'buster direct' && echo; done | wc -l) of 34 direct"
    clang -o "$out/lua-$v" $(ls "$out"/o-$v/*.o | grep -v '/luac.o') -lm -Wl,-E -ldl
    (cd "$tests" && timeout 900 "$out/lua-$v" -e"_U=true" all.lua > "$out/all-$v.log" 2>&1); echo "$v: status $?, $(grep -c 'final OK' "$out/all-$v.log") 'final OK'"
done
