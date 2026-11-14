#!/bin/bash
# The baseline at main: build, benchmark-tier1-frame, and the planner's share of --tier1 -c sqlite3.c by an rdtsc probe.
cd $HOME/buster-fast-bench/2699-claude || exit 1
export EXCLUSIVE_OWNER=claude-2699 EXCLUSIVE_TITLE="Zen 5 kernel: frame planner (#2699)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2699
X=$HOME/buster-fast-bench/exclusive.sh
mkdir -p logs out
state() { echo "== $(date -u +%FT%TZ) loadavg $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; }
test -d corpus || BUSTER_CI_CACHE=$HOME/.cache/buster/ci bash main/tools/ci/fetch-corpus.sh $PWD/corpus > logs/fetch.log 2>&1
if ! test -x compiler-main; then
    (cd main && $X env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > logs/build-main.log 2>&1
    cp main/build/compiler compiler-main
fi
if ! test -x compiler-probe; then
    rm -rf probe && git -C main worktree add -q --detach ../probe HEAD && python3 probe.py probe
    (cd probe && $X env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > logs/build-probe.log 2>&1
    cp probe/build/compiler compiler-probe
fi
for round in 1 2; do
    $X bash -c "$(declare -f state); state; taskset -c 2 ./compiler-main benchmark-tier1-frame; state" > logs/frame-main-$round.log 2>&1
done
$X bash -c "$(declare -f state); state; for i in 1 2 3 4 5 6 7; do BUSTER_FRAME_PROBE=1 taskset -c 2 ./sq.sh ./compiler-probe out/probe.o --lanes 1; done; for i in 1 2 3; do BUSTER_FRAME_PROBE=1 taskset -c 2 ./sq.sh ./compiler-probe out/probe-scalar.o --lanes 1 --scalar; done; state" > logs/probe-sqlite.log 2>&1
$X bash -c "$(declare -f state); state; taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u,task-clock ./sq.sh ./compiler-main out/main.o --lanes 1; state" > logs/stat-main.log 2>&1
echo done > logs/q1.done
