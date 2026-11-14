#!/bin/bash
# campaign.sh COMPILER SEED COUNT OUTPUT: one test-differential campaign of COUNT programs per generator from SEED, where
# the harness's first mode ("tier 0") is --tier1 --tier1-no-inline and its second ("tier 1") is --tier1 with #2541's
# inlining, against clang -O0 and -O2 (the harness's clang modes); -fno-asynchronous-unwind-tables as the records'.
set -u
compiler=$1; seed=$2; count=$3; output=$4
gen=$HOME/.cache/claude-2541/gen
"$compiler" test-differential --buster "$compiler" \
    --tier0-arg --tier1 --tier0-arg --tier1-no-inline --tier0-arg -fno-asynchronous-unwind-tables \
    --tier1-arg --tier1 --tier1-arg -fno-asynchronous-unwind-tables --tier1-arg --tier1-report \
    --csmith "$gen/csmith-install/bin/csmith" --csmith-include "$gen/csmith-install/include" --yarpgen "$gen/yarpgen/build/yarpgen" \
    --clang clang --generator both --seed "$seed" --count "$count" --timeout-ms 30000 \
    --revision "${REVISION:-$(git -C /home/user/buster rev-parse HEAD)}" --generator-revision "csmith=0cdc710315cfee9035e22ef4363ca479270d1934,yarpgen=1adb290f453505838f3aa33dc571f292b0c1810f" \
    --output "$output"
