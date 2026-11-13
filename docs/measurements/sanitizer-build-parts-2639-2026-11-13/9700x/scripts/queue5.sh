#!/bin/bash
# After queue4: builds shaped as a hosted runner's (2 cores, 2 jobs), whole and in parts, for the x86-64 MSan row's
# product (405.1 s on the merge queue's runner, job 131922187378) and the vector ASan configuration's.
cd ~/buster-fast-bench/2639-claude
while pgrep -x queue4.sh > /dev/null; do sleep 10; done
./hosted-build.sh hosted-base-x86-64-memory src x86-64 memory
./hosted-build.sh hosted-split-x86-64-memory split x86-64 memory
./hosted-build.sh hosted-base-vector-address src vector address
./hosted-build.sh hosted-split-vector-address split vector address
