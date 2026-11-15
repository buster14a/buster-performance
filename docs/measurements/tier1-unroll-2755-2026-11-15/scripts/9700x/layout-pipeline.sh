#!/usr/bin/env bash
# layout-pipeline.sh: layout.sh's build, then a warm-up round (0) and seven rounds, each step in its own lock hold.
# Started by systemd-run; writes layout.done.
set -u
cd ~/buster-fast-bench/2755-claude/layout || exit 1
export EXCLUSIVE_OWNER=claude-2755
export EXCLUSIVE_TITLE="Issue 2755: Tier 1 loop unrolling (layouts)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2755
LOCK=~/buster-fast-bench/exclusive.sh
rm -f layout.done
$LOCK ./layout.sh build > build.txt 2>&1
for round in 0 1 2 3 4 5 6 7; do
    $LOCK ./layout.sh round $round >> runs.txt 2> round-$round.err
done
echo done > layout.done
