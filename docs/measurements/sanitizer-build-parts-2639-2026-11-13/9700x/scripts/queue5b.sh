#!/bin/bash
# After queue5: the hosted-shaped x86-64 MSan builds with 4 jobs, a job a hardware thread of the 2 cores, whole and in
# parts, against build.sh's default of 2 (a job a core).
cd ~/buster-fast-bench/2639-claude
while pgrep -x queue5.sh > /dev/null; do sleep 10; done
JOBS=4 ./hosted-build.sh hosted4-base-x86-64-memory src x86-64 memory
JOBS=4 ./hosted-build.sh hosted4-split-x86-64-memory split x86-64 memory
