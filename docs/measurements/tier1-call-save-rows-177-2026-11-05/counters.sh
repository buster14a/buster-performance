#!/usr/bin/env bash
# callsave counters: closures.lua's front end and memory counters, main's and head's Tier 1 Lua at code shifts 0, 32 and
# 96 (out4's executables), 5 rounds alternating, each run one hold, pinned to CPU 2.
set -u
W=$HOME/buster-fast-bench/177-callsave-claude
export EXCLUSIVE_OWNER=claude-177-callsave EXCLUSIVE_TITLE='Problems 141, 177, 789' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1433
L="$HOME/buster-fast-bench/exclusive.sh"
O=$W/out4
E=cycles:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u,de_src_op_disp.x86_decoder:u,ls_bad_status2.stli_other:u,ls_stlf:u
cd $O || exit 1
: > counters.txt
for round in 1 2 3 4 5; do
    for n in 0 32 96; do
        order="main head"; [ $((round % 2)) = 0 ] && order="head main"
        for c in $order; do
            $L bash -c "cd $O && taskset -c 2 perf stat -x, -e $E -o counters-one.txt ./lua-$c-p$n closures.lua > /dev/null 2>&1"
            awk -F, -v c=$c -v r=$round -v p=$n 'BEGIN{ORS=""; print p, r, c} /^[0-9]/{print " " $3 "=" $1} END{print "\n"}' counters-one.txt >> counters.txt
        done
    done
done
echo done > counters.done
