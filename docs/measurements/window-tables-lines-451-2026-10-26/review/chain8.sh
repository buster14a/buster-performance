#!/usr/bin/env bash
cd ~/buster-fast-bench/perf-451-claude || exit 1
while kill -0  2>/dev/null; do sleep 5; done
./builds.sh rhead2 >> builds.log 2>&1
./review3.sh 5 rbase rhead16 rhead2 > review3.log 2>&1
echo "== chain8 done $(date +%T)"
