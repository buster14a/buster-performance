#!/bin/bash
# usage: q2.sh TAG REF: build REF as head-TAG (and its probe), benchmark-tier1-frame, the twin check, the planner's share
# and whole-compile counters against main.
tag=$1; ref=$2
cd $HOME/buster-fast-bench/2699-claude || exit 1
export EXCLUSIVE_OWNER=claude-2699 EXCLUSIVE_TITLE="Zen 5 kernel: frame planner (#2699)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2763
X=$HOME/buster-fast-bench/exclusive.sh
mkdir -p logs out
state() { echo "== $(date -u +%FT%TZ) loadavg $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; }
if ! test -x compiler-head-$tag; then
    git -C main fetch -q origin "$ref" || exit 1
    commit=$(git -C main rev-parse FETCH_HEAD)
    git -C main worktree remove --force ../head-$tag 2>/dev/null; git -C main worktree prune
    git -C main worktree add -q --detach ../head-$tag $commit || exit 1
    echo "$commit" > logs/head-$tag.commit
    (cd head-$tag && $X env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > logs/build-head-$tag.log 2>&1
    cp head-$tag/build/compiler compiler-head-$tag || exit 1
fi
for round in 1 2; do
    $X bash -c "$(declare -f state); state; taskset -c 2 ./compiler-head-$tag benchmark-tier1-frame; state" > logs/frame-head-$tag-$round.log 2>&1
done
$X bash -c "$(declare -f state); state; ./sq.sh ./compiler-head-$tag out/head-$tag.o --lanes 1; ./sq.sh ./compiler-head-$tag out/head-$tag-scalar.o --lanes 1 --scalar; ./sq.sh ./compiler-main out/main.o --lanes 1; sha256sum out/head-$tag.o out/head-$tag-scalar.o out/main.o; ./compiler-head-$tag test-tier1-frame; state" > logs/twin-$tag.log 2>&1
$X bash -c "$(declare -f state); state; for i in 1 2 3 4 5 6 7; do for b in main head-$tag; do echo \"run \$b\"; taskset -c 2 perf stat -x, -e cycles:u,instructions:u,task-clock ./sq.sh ./compiler-\$b out/stat.o --lanes 1; done; done; state" > logs/stat-$tag.log 2>&1
if ! test -x compiler-probe-$tag; then
    python3 probe.py head-$tag
    (cd head-$tag && $X env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > logs/build-probe-$tag.log 2>&1
    cp head-$tag/build/compiler compiler-probe-$tag
    git -C head-$tag checkout -q src/buster/compiler/tier1_frame.c
fi
$X bash -c "$(declare -f state); state; for i in 1 2 3 4 5 6 7; do BUSTER_FRAME_PROBE=1 taskset -c 2 ./sq.sh ./compiler-probe-$tag out/probe.o --lanes 1 2>&1 | grep FRAMEPROBE | tail -1; done; for i in 1 2 3; do BUSTER_FRAME_PROBE=1 taskset -c 2 ./sq.sh ./compiler-probe-$tag out/probe-scalar.o --lanes 1 --scalar 2>&1 | grep FRAMEPROBE | tail -1; done; state" > logs/probe-sqlite-$tag.log 2>&1
echo done > logs/q2-$tag.done
