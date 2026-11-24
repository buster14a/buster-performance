#!/usr/bin/env bash
set -eu
cd "$HOME/buster-fast-bench/1340-codex-20261124"
export EXCLUSIVE_OWNER=codex-1340 EXCLUSIVE_TITLE="Issue 1340 current warning profile" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340
if [[ ${1:-} != locked ]]; then
    exec "$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 90 bash "$0" locked
fi
SCRATCH=objects
source src/tools/microarch/workloads.sh
workload base sq-c
taskset -c 2 perf record -q -o base-cycles.data -e cycles:u -F 3999 -- bash -c 'for ((i=0;i<25;i++)); do "$@" || exit 1; done' _ "${WL[@]}"
perf report -i base-cycles.data --stdio --no-children --percent-limit 0.1 --sort dso,symbol > base-cycles.txt
