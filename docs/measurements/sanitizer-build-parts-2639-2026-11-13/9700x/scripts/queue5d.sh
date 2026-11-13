#!/bin/bash
# In place of queue5c's rest (stopped after its first run, cores4-base-x86-64-memory): x86-64 MSan in parts on four
# cores of one thread each (CPUs 4-7, 4 jobs); then the hosted runner's shape as CI builds it (2 cores of 2 threads,
# --jobs "$(nproc)" = 4, tools/ci/hosted-product.sh) for vector ASan, whole and in parts.
cd ~/buster-fast-bench/2639-claude
while pgrep -f "[h]osted-build.sh cores4-base-x86-64-memory" > /dev/null; do sleep 10; done
CPUS=4,5,6,7 ./hosted-build.sh cores4-split-x86-64-memory split x86-64 memory
JOBS=4 ./hosted-build.sh hosted4-base-vector-address src vector address
JOBS=4 ./hosted-build.sh hosted4-split-vector-address split vector address
