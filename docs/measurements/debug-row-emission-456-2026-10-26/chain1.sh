#!/usr/bin/env bash
cd ~/buster-fast-bench/perf-456-claude || exit 1
while kill -0 879873 2>/dev/null; do sleep 5; done
./builds.sh vM >> builds.log 2>&1
./emit.sh 5 main vM > emit-vM.log 2>&1
./counts.sh main head426 prior426 vM screen:0 screen:1 screen:3 screen:7 screen:15 > counts.log 2>&1
echo "== chain1 done $(date +%T)"
