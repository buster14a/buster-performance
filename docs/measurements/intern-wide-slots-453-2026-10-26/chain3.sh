#!/usr/bin/env bash
cd ~/buster-fast-bench/perf-453-claude || exit 1
while kill -0 1000968 2>/dev/null; do sleep 5; done
./builds.sh main453 narrow wide > builds.log 2>&1
./refine.sh 5 main453 narrow wide > refine.log 2>&1
echo "== chain3 done $(date +%T)"
