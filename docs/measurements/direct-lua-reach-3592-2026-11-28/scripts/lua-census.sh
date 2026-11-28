#!/bin/bash
# lua-census.sh COMPILER LUA_SRC OUT: every Lua unit compiled by -c with its Makefile's flags but -Wall -Wextra (which keep
# the direct path off), a process each; prints each unit's path (.comment of its object) and, for a unit that left, the
# direct path's refusing rule (BUSTER_TEST_DIRECT_BAILS). EXTRA adds options.
set -uo pipefail
bin=$1; src=$2; out=$3
mkdir -p "$out/o"
flags=(-std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX ${EXTRA:-})
: > "$out/bails.txt"
for f in "$src"/*.c; do
    n=$(basename "$f" .c)
    rm -f "$out/o/$n.o"
    BUSTER_TEST_DIRECT_BAILS="$out/bail.$n" "$bin" --lanes 1 "${flags[@]}" -c "$f" -o "$out/o/$n.o" 2> "$out/o/$n.err"
    st=$?
    path=$(readelf -p .comment "$out/o/$n.o" 2>/dev/null | grep -o 'buster direct\|buster-fast' | head -1)
    reason=$(cat "$out/bail.$n" 2>/dev/null | head -1)
    rm -f "$out/bail.$n"
    printf '%-10s status=%d %-14s %s\n' "$n" "$st" "${path:-none}" "$reason" | tee -a "$out/bails.txt"
done
echo "direct: $(grep -c 'buster direct' "$out/bails.txt") of $(ls "$src"/*.c | wc -l)"
