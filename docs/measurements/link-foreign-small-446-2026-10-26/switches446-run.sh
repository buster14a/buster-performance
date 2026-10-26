#!/bin/bash
set -u
cd ~/buster-fast-bench/perf-445-446-claude
while read -r t command; do
    perf record -q -e context-switches -c 1 --call-graph dwarf,16384 -o "switches-$t.data" -- \
        bash -c "for i in \$(seq 22); do sleep 0.02; $command || exit 1; done" || exit 1
done < switches446.list
