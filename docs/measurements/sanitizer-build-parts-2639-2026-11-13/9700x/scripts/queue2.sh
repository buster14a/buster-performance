#!/bin/bash
# After queue1 (the baselines): the checker unit traced alone under MSan, then the split branch clean builds.
cd ~/buster-fast-bench/2639-claude
while pgrep -x queue1.sh > /dev/null; do sleep 10; done
./trace-unit.sh trace-memory-checker memory main_unit_checker.c
TREE=split ./build-clean.sh split-memory memory
TREE=split ./build-clean.sh split-address address
TREE=split ./build-clean.sh split-thread thread
