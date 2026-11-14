#!/usr/bin/env bash
# luaprof.sh: Lua's arithmetic script by each build at link orders 1, 4 (head slower) and 5 (head faster), in one hold:
# five perf stat runs of front-end and branch counters, and one perf record of cycles:u, pinned to CPU 2.
set -u
W=$HOME/buster-fast-bench/2618e-claude
export EXCLUSIVE_OWNER=claude-2618 EXCLUSIVE_TITLE='GitHub issue #2618 (rest) and #2685: Lua arithmetic profile' EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQsNkec1N4WJ65hh6VB
mkdir -p $W/luaprof
cat > $W/luaprof/one.sh <<EOS
set -u
head -1 /var/lib/buster-9700x/owner >> $W/holds.txt
cd $W/inputs
for k in 1 2 3 4 5; do
  for o in 1 4 5; do
    for t in base head; do
      taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u,L1-icache-load-misses:u,ic_tag_hit_miss.instruction_cache_miss:u -o $W/luaprof/stat-\$t-o\$o-\$k.txt $W/lua-\$t-o\$o arithmetic.lua > /dev/null 2>&1
      taskset -c 2 perf stat -x, -e cycles:u,ex_ret_brn_misp:u,bp_l1_tlb_miss_l2_tlb_hit:u,ls_stlf:u,ls_bad_status2.stli_other:u,de_src_op_disp.x86_decoder:u,de_src_op_disp.op_cache:u -o $W/luaprof/fe-\$t-o\$o-\$k.txt $W/lua-\$t-o\$o arithmetic.lua > /dev/null 2>&1
    done
  done
done
for o in 1 4 5; do
  for t in base head; do
    taskset -c 2 perf record -q -e cycles:u -c 50021 -o $W/luaprof/\$t-o\$o.data $W/lua-\$t-o\$o arithmetic.lua > /dev/null 2>&1
  done
done
EOS
timeout 600 ~/buster-fast-bench/exclusive.sh bash $W/luaprof/one.sh
echo "exit $?" > $W/luaprof/done
