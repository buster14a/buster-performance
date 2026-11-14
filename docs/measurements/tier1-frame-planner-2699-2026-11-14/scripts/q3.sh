#!/bin/bash
# usage: q3.sh TAG: the phases per function at real frame sizes, and across the rank sort's limit (32 objects).
tag=$1
cd $HOME/buster-fast-bench/2699-claude || exit 1
export EXCLUSIVE_OWNER=claude-2699 EXCLUSIVE_TITLE="Zen 5 kernel: frame planner (#2699)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2763
X=$HOME/buster-fast-bench/exclusive.sh
state() { echo "== $(date -u +%FT%TZ) loadavg $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; }
until test -x compiler-head-$tag; do sleep 5; done
for b in main head-$tag; do
    $X bash -c "$(declare -f state); state; for n in 1 2 4 8 16 32 33 48 64 128; do echo \"count \$n\"; taskset -c 2 ./compiler-$b benchmark-tier1-frame --count \$n; done; state" > logs/sizes-$b.log 2>&1
done
echo done > logs/q3-$tag.done
