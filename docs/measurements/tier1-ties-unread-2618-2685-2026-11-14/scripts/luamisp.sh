#!/usr/bin/env bash
# luamisp.sh: where Lua's arithmetic script mispredicts, by each build at link orders 1 (head +330K misses) and 5 (none):
# perf record of ex_ret_brn_misp:u every 211 and of IBS ops, pinned to CPU 2, in one hold.
set -u
W=$HOME/buster-fast-bench/2618e-claude
export EXCLUSIVE_OWNER=claude-2618 EXCLUSIVE_TITLE='GitHub issue #2618 (rest) and #2685: Lua arithmetic mispredictions' EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQsNkec1N4WJ65hh6VB
cat > $W/luaprof/misp.sh <<EOS
set -u
head -1 /var/lib/buster-9700x/owner >> $W/holds.txt
cd $W/inputs
for o in 1 5; do
  for t in base head; do
    taskset -c 2 perf record -q -e ex_ret_brn_misp:u -c 211 -o $W/luaprof/misp-\$t-o\$o.data $W/lua-\$t-o\$o arithmetic.lua > /dev/null 2>&1
  done
done
EOS
timeout 900 ~/buster-fast-bench/exclusive.sh bash $W/luaprof/misp.sh
echo "exit $?" > $W/luaprof/misp-done
