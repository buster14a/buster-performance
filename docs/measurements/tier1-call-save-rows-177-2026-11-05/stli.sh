#!/usr/bin/env bash
# callsave stli: where closures.lua's store-to-load interlock failures (ls_bad_status2.stli_other) are, in main's and
# head's Tier 1 Lua (out4's, no shift), each record one hold, pinned to CPU 2.
set -u
W=$HOME/buster-fast-bench/177-callsave-claude
export EXCLUSIVE_OWNER=claude-177-callsave EXCLUSIVE_TITLE='Problems 141, 177, 789' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1433
L="$HOME/buster-fast-bench/exclusive.sh"
O=$W/out4
cd $O || exit 1
for c in main head; do
    $L bash -c "cd $O && taskset -c 2 perf record -q -e ls_bad_status2.stli_other:u -c 1000 -o stli-$c.data ./lua-$c-p0 closures.lua > /dev/null 2>&1"
    perf report -i stli-$c.data --stdio --sort sym 2>/dev/null | grep -v '^#' | grep -v '^$' | head -12 > stli-$c-symbols.txt
    perf report -i stli-$c.data --stdio --sort sym,srcline -F overhead,sym 2>/dev/null > /dev/null
    perf annotate -i stli-$c.data --stdio -s luaD_precall 2>/dev/null | grep -E '^ +[0-9]+\.[0-9]+' | sort -rn | head -12 > stli-$c-precall.txt
    perf report -i stli-$c.data --stdio --sort sym,addr 2>/dev/null | grep -v '^#' | grep -v '^$' | head -1 > /dev/null
done
echo done > stli.done
