#!/usr/bin/env bash
cd ~/buster-fast-bench/perf-451-claude || exit 1
while kill -0 1818441 2>/dev/null; do sleep 5; done
./builds.sh final451 sub4 >> builds.log 2>&1
./phases.sh 5 main451 final451 > ab.log 2>&1
./phases.sh 3 sub4 > sub4.log 2>&1
echo "== chain5 done $(date +%T)"
