#!/bin/bash
# #1450 item 6: where Tier 0's closures.lua cost under -fstack-clash-protection goes. #177's Lua builds by 903c464e
# (lua-t0 without the option, lua-t0p with it; lua-t1 and lua-t1p by --tier1), each run one hold of the lock, pinned
# to CPU 2: counters over alternating rounds, then one cycles profile of each.
set -u
W=~/buster-fast-bench/1450-claude/item6
L="env EXCLUSIVE_OWNER=claude-1450 EXCLUSIVE_TITLE=GitHub_issue_1450 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1450 $HOME/buster-fast-bench/exclusive.sh"
S=~/buster-fast-bench/177-probes-claude/out/lua
mkdir -p $W && cd $W
cp $S/lua-t0 $S/lua-t0p $S/lua-t1 $S/lua-t1p $S/closures.lua .
sha256sum lua-t0 lua-t0p lua-t1 lua-t1p closures.lua > inputs.txt
E=cycles:u,instructions:u,ls_stlf,ls_bad_status2.stli_other,ls_dispatch.store_dispatch,ls_dispatch.ld_dispatch
: > counters.csv
for round in 1 2 3 4 5; do
  for c in t0 t0p t1 t1p; do
    $L taskset -c 2 perf stat -x, -e $E -o stat-$c-$round.txt ./lua-$c closures.lua > /dev/null 2>&1
    grep -v '^#' stat-$c-$round.txt | grep -v '^$' | awk -F, -v r=$round -v c=$c '{print r","c","$3","$1}' >> counters.csv
  done
done
for c in t0 t0p; do
  $L taskset -c 2 perf record -q -e cycles:u -c 200000 -o rec-$c.data ./lua-$c closures.lua > /dev/null 2>&1
  perf report -q -i rec-$c.data --stdio --sort symbol -F overhead,sample,symbol 2>/dev/null | head -40 > rec-$c.txt
done
echo done > profile.done
