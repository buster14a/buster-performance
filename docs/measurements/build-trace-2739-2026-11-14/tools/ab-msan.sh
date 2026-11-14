#!/bin/bash
# Clean untraced x86-64 MSan Release builds, CI's shape: the change, then main.
S=/tmp/claude-0/-home-user/f3359c51-4471-5361-8c60-50e865da18b2/scratchpad
D=$(bash /home/user/wt-trace/tools/ci/session-toolchain.sh stage)
export PATH="$D:$PATH" BUSTER_HOST_ARCH=x86-64 BUSTER_SANITIZER=memory BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_DEBUG_INFO=0
for tree in "$@"; do
    name=$(basename $tree)
    rm -rf $tree/build/cmake/x86-64-memory-O3
    cd $tree
    start=$(date +%s.%N)
    ./build.sh --config Release --jobs 4 > $S/ab-$name.log 2>&1
    status=$?
    end=$(date +%s.%N)
    echo "$name status $status wall $(echo "$end - $start" | bc)" >> $S/ab-msan.result
    cp build/cmake/x86-64-memory-O3/.ninja_log $S/ab-$name.ninja_log
    cp -p build/cmake/x86-64-memory-O3/Release/compiler $S/ab-$name.compiler
    grep "build.sh: Release:" $S/ab-$name.log >> $S/ab-msan.result
done
