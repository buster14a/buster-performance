#!/usr/bin/env bash
cd ~/buster-fast-bench/perf-451-claude || exit 1
./builds.sh switch451 >> builds.log 2>&1
./review4.sh 7 switch451 > review4.log 2>&1
echo "== chain9 done $(date +%T)"
