#!/usr/bin/env bash
# The twin checks of one tree: the issue's functions, Lua's 34 units and sqlite3.c by --tier1 and --tier1 --scalar,
# and 48 random programs' two native executables (test-ssa-source --tier1 --keep), compared byte for byte.
set -u
root=$HOME/buster-fast-bench/1395-claude-2hegka
tree=$1
c=$root/$tree/build/compiler
work=$root/twins-$tree
rm -rf "$work"; mkdir -p "$work/ssa"; cd "$work"
echo "issue: $("$root/bench/twins.sh" "$c" out-issue "$root/inputs/issue/issue.c" | tr '\n' ' ')"
echo "lua: $("$root/bench/twins.sh" "$c" out-lua --flags "-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX" "$root"/inputs/lua-5.4.8/src/*.c | tr '\n' ' ')"
echo "sqlite: $("$root/bench/twins.sh" "$c" out-sqlite --flags "-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE" "$root/inputs/sqlite/sqlite3.c" | tr '\n' ' ')"
TMPDIR=$work/ssa "$c" test-ssa-source --tier1 --generate 48 --seed 1 --lifetimes --clang clang --keep > ssa.log 2>&1
echo "ssa status $? $(grep -o 'native_programs=[0-9]* native_passed=[0-9]*' ssa.log)"
same=0; differ=0
for v in ssa/*/run-*-tier1-vector; do
    if cmp -s "$v/program" "${v%-vector}-scalar/program"; then same=$((same + 1)); else differ=$((differ + 1)); fi
done
echo "ssa executables: same=$same differ=$differ"
rm -rf ssa
