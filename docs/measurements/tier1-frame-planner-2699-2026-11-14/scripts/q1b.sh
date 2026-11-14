#!/bin/bash
# Main's probe again: the first probe printed from a destructor, which this executable doesn't run.
cd $HOME/buster-fast-bench/2699-claude || exit 1
export EXCLUSIVE_OWNER=claude-2699 EXCLUSIVE_TITLE="Zen 5 kernel: frame planner (#2699)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2763
X=$HOME/buster-fast-bench/exclusive.sh
state() { echo "== $(date -u +%FT%TZ) loadavg $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; }
git -C probe checkout -q src/buster/compiler/tier1_frame.c && python3 probe.py probe
(cd probe && $X env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > logs/build-probe.log 2>&1
cp probe/build/compiler compiler-probe
$X bash -c "$(declare -f state); state; for i in 1 2 3 4 5 6 7; do BUSTER_FRAME_PROBE=1 taskset -c 2 ./sq.sh ./compiler-probe out/probe.o --lanes 1 2>&1 | grep FRAMEPROBE | tail -1; done; for i in 1 2 3; do BUSTER_FRAME_PROBE=1 taskset -c 2 ./sq.sh ./compiler-probe out/probe-scalar.o --lanes 1 --scalar 2>&1 | grep FRAMEPROBE | tail -1; done; state" > logs/probe-sqlite.log 2>&1
echo done > logs/q1b.done
