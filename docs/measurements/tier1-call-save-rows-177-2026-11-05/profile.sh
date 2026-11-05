#!/usr/bin/env bash
# callsave profile: where closures.lua's cycles go in main's and head's Tier 1 Lua, each record one hold, pinned to CPU 2.
set -u
W=$HOME/buster-fast-bench/177-callsave-claude
export EXCLUSIVE_OWNER=claude-177-callsave EXCLUSIVE_TITLE='Problems 141, 177, 789' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1433
L="$HOME/buster-fast-bench/exclusive.sh"
mkdir -p $W/out3 && cd $W/out/lua || exit 1
for c in t1main t1head t1main t1head; do
    $L taskset -c 2 perf record -q -e cycles:u -F 25000 -o $W/out3/$c.data ./lua-$c closures.lua > /dev/null 2>&1
done
for c in t1main t1head; do
    perf report -i $W/out3/$c.data --stdio --sort sym 2>/dev/null | grep -v '^#' | grep -v '^$' | head -15 > $W/out3/$c-symbols.txt
    perf stat -x, -e task-clock -o /dev/null true
done
# Each hot function's size and address, in both executables.
for c in t1main t1head; do
    nm -S --size-sort ./lua-$c | tail -25 > $W/out3/$c-sizes.txt
    nm ./lua-$c | grep -E ' (luaV_execute|luaD_precall|luaD_poscall|luaF_close|luaF_newLclosure|luaF_findupval|luaH_getshortstr|luaC_step|luaD_pretailcall|ccall|luaV_finishget)$' > $W/out3/$c-addresses.txt
done
echo done > $W/out3/done
