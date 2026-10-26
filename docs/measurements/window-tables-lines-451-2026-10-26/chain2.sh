#!/usr/bin/env bash
cd ~/buster-fast-bench/perf-451-claude || exit 1
while kill -0 934915 2>/dev/null; do sleep 5; done
./builds.sh sub sub3 > builds.log 2>&1
./phases.sh 5 sub sub3 > phases.log 2>&1
echo "== chain2 done $(date +%T)"
