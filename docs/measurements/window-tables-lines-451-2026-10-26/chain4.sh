#!/usr/bin/env bash
cd ~/buster-fast-bench/perf-451-claude || exit 1
while kill -0 1000968 2>/dev/null; do sleep 5; done
./builds.sh sub2 >> builds.log 2>&1
./variants.sh 5 sub2 > variants.log 2>&1
echo "== chain4 done $(date +%T)"
