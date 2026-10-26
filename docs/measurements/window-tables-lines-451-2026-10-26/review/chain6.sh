#!/usr/bin/env bash
cd ~/buster-fast-bench/perf-451-claude || exit 1
./builds.sh rbase rprev rhead >> builds.log 2>&1
./review.sh 5 rbase rprev rhead > review.log 2>&1
echo "== chain6 done $(date +%T)"
