#!/bin/bash
# #172's relative-layout check (docs/commands/profiling.md, #1450): Lua's objects compiled once per variant, relinked in
# the same recorded object orders for every variant, each script timed by time-runs over every (variant, order) on CPU 2.
# Each step under the shared lock on its own.
set -u
cd ~/buster-fast-bench/172-claude
export EXCLUSIVE_OWNER=claude-172 EXCLUSIVE_TITLE="Solve 172: Tier 1 scheduling layouts" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/172
X=~/buster-fast-bench/exclusive.sh
R=results/${1:-layouts}
mkdir -p "$R"
unset CPATH C_INCLUDE_PATH
IN=$PWD/inputs
C=$PWD/tree/build/compiler
W=$PWD/work-layouts
rm -rf "$W"; mkdir -p "$W"
SOURCES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
step() { echo "== $(date -u +%FT%TZ) $*"; }
# The orders: the Makefile's, then seven permutations from a fixed seed, recorded before any timing.
echo $SOURCES | tr ' ' '\n' > "$R/order-0.txt"
for k in 1 2 3 4 5 6 7; do
  echo $SOURCES | tr ' ' '\n' | shuf --random-source=<(yes "buster-172-layout-$k") > "$R/order-$k.txt"
done
step objects
$X sh -c "set -e; for v in none post pre; do mkdir -p $W/\$v; for s in $SOURCES; do \"$C\" --tier1 -fno-asynchronous-unwind-tables --tier1-schedule=\$v -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $IN/lua-5.4.8/src/\$s.c -o $W/\$v/\$s.o; done; done" > "$R/objects.txt" 2>&1 || { echo objects failed; exit 1; }
step link
$X sh -c "set -e; for v in none post pre; do for k in 0 1 2 3 4 5 6 7; do clang -o $W/lua-\$v-\$k \$(sed \"s|^|$W/\$v/|; s|\$|.o|\" $R/order-\$k.txt) -lm -ldl; done; done" > "$R/link.txt" 2>&1 || { echo link failed; exit 1; }
sha256sum $W/none/*.o $W/post/*.o $W/pre/*.o $W/lua-* > "$R/binaries.sha256"
step check
ok=1
for s in calls tables strings arithmetic closures; do
  "$W/lua-none-0" "$IN/scripts/$s.lua" > "$W/$s.expected" 2>&1
  for v in none post pre; do for k in 0 1 2 3 4 5 6 7; do
    "$W/lua-$v-$k" "$IN/scripts/$s.lua" > "$W/$s.out" 2>&1 && cmp -s "$W/$s.out" "$W/$s.expected" || { echo "$s by $v order $k differs"; ok=0; }
  done; done
done
echo "outputs agree: $ok" | tee "$R/check.txt"
[ $ok = 1 ] || exit 1
for s in calls tables strings arithmetic closures; do
  step "time $s"
  args=()
  for v in none post pre; do for k in 0 1 2 3 4 5 6 7; do args+=(--build "$v" "$W/lua-$v-$k"); done; done
  $X taskset -c 2 "$C" time-runs --runs 11 --warmups 1 "${args[@]}" --list "$IN/scripts/$s.lua" > "$R/time-$s.txt" 2>&1
  echo "status $?" >> "$R/time-$s.txt"; tail -1 "$R/time-$s.txt"
done
step done
