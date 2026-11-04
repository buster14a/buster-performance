#!/usr/bin/env bash
# #142's campaign at buster#1245's tree (f3de5433), in the cloud container: seeds 3400 to 3439 of both generators,
# two seeds a chunk, Tier 0 and --tier1 (PASS=vector) or --tier1 --scalar (PASS=scalar), against clang -O0 and -O2.
set -u
S=$SCRATCH
G=$S/gen
B=$S/campaign/compiler-f3de5433
PASS=$1
OUT=$S/campaign/$PASS
mkdir -p $OUT
extra=()
[ "$PASS" = scalar ] && extra=(--tier1-arg --scalar)
for seed in $(seq 3400 2 3438); do
    "$B" test-differential --buster "$B" --tier0-default --tier1-arg --tier1 "${extra[@]}" --tier1-arg -fno-asynchronous-unwind-tables \
        --csmith $G/csmith-install/bin/csmith --csmith-include $G/csmith-install/include --yarpgen $G/yarpgen/build/yarpgen \
        --clang clang --generator both --seed $seed --count 2 --timeout-ms 30000 --revision f3de54339ea07ccc3e2c08d5d1f37f7931f4359f \
        --generator-revision "csmith 0cdc710315cfee9035e22ef4363ca479270d1934; yarpgen 1adb290f453505838f3aa33dc571f292b0c1810f" \
        --output $OUT/chunk-$seed > $OUT/chunk-$seed.log 2>&1
    echo "chunk-$seed exit $?" >> $OUT/progress.log
done
touch $OUT/done
