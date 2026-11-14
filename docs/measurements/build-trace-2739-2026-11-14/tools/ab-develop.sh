#!/bin/bash
# Clean native Develop builds (build.sh's default), CI's toolchain: each tree given.
S=/tmp/claude-0/-home-user/f3359c51-4471-5361-8c60-50e865da18b2/scratchpad
D=$(bash /home/user/wt-trace/tools/ci/session-toolchain.sh stage)
export PATH="$D:$PATH"
for tree in "$@"; do
    name=$(basename $tree)
    variant=$(cd $tree && ./build.sh print-output --config Develop | sed 's|/Develop/compiler$||')
    rm -rf "$variant"
    cd $tree
    start=$(date +%s.%N)
    ./build.sh --jobs 4 > $S/dev-$name.log 2>&1
    status=$?
    end=$(date +%s.%N)
    echo "$name status $status wall $(echo "$end - $start" | bc) tree $variant" >> $S/ab-develop.result
    cp $variant/.ninja_log $S/dev-$name.ninja_log
    cp -p $variant/Develop/compiler $S/dev-$name.compiler
    grep "build.sh: Develop:" $S/dev-$name.log >> $S/ab-develop.result
done
