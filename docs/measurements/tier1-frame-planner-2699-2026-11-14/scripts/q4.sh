#!/bin/bash
# usage: q4.sh TAG: the planner's ticks in --tier1 -c sqlite3.c with one line printed at the compile's last plan (its
# 1,368th), for main and head-TAG: the first probe printed after every plan, a write between each plan and the next.
tag=$1
cd $HOME/buster-fast-bench/2699-claude || exit 1
export EXCLUSIVE_OWNER=claude-2699 EXCLUSIVE_TITLE="Zen 5 kernel: frame planner (#2699)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2763
X=$HOME/buster-fast-bench/exclusive.sh
state() { echo "== $(date -u +%FT%TZ) loadavg $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; }
until test -f logs/q2-$tag.done; do sleep 5; done
git -C probe checkout -q src/buster/compiler/tier1_frame.c && python3 probe2.py probe
(cd probe && $X env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > logs/build-probe2-main.log 2>&1
cp probe/build/compiler compiler-probe2-main
git -C head-$tag checkout -q src/buster/compiler/tier1_frame.c && python3 probe2.py head-$tag
(cd head-$tag && $X env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > logs/build-probe2-$tag.log 2>&1
cp head-$tag/build/compiler compiler-probe2-$tag
git -C head-$tag checkout -q src/buster/compiler/tier1_frame.c
$X bash -c "$(declare -f state); state; for i in 1 2 3 4 5 6 7 8 9; do for b in main $tag; do echo \"run \$b vector\"; BUSTER_FRAME_PROBE=1368 taskset -c 2 ./sq.sh ./compiler-probe2-\$b out/probe2.o --lanes 1 2>&1 | grep FRAMEPROBE; done; done; for i in 1 2 3 4 5; do for b in main $tag; do echo \"run \$b scalar\"; BUSTER_FRAME_PROBE=1368 taskset -c 2 ./sq.sh ./compiler-probe2-\$b out/probe2.o --lanes 1 --scalar 2>&1 | grep FRAMEPROBE; done; done; state" > logs/probe2-$tag.log 2>&1
echo done > logs/q4-$tag.done
