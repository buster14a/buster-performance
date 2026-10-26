#!/usr/bin/env bash
cd ~/buster-fast-bench/perf-451-claude || exit 1
while kill -0 3407575 2>/dev/null; do sleep 5; done
./builds.sh rhead16 >> builds.log 2>&1
./review2.sh 5 rbase rhead rhead16 > review2.log 2>&1
echo "== chain7 done $(date +%T)"
