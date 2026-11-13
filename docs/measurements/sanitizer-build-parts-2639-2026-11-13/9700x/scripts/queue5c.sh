#!/bin/bash
# After queue5b: whole and split builds on four cores of one thread each (CPUs 4-7, build.sh's 4 jobs), between the
# hosted runner's 2 cores and the 9700X's 8: x86-64 MSan and vector ASan.
cd ~/buster-fast-bench/2639-claude
while pgrep -x queue5b.sh > /dev/null; do sleep 10; done
CPUS=4,5,6,7 ./hosted-build.sh cores4-base-x86-64-memory src x86-64 memory
CPUS=4,5,6,7 ./hosted-build.sh cores4-split-x86-64-memory split x86-64 memory
CPUS=4,5,6,7 ./hosted-build.sh cores4-base-vector-address src vector address
CPUS=4,5,6,7 ./hosted-build.sh cores4-split-vector-address split vector address
