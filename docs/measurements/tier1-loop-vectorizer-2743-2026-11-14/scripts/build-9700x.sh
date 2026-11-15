#!/usr/bin/env bash
# build-9700x.sh MARCH: the kernels' unit by each configuration, each linked with clang -O2's harness behind 0, 16, 32
# and 48 bytes of padding (buster-tier1-hand and clang-O2-hand at znver5 alone). Environment: BUSTER (the branch's
# Release compiler), MAIN (main's), CLANG. Run under the lock.
set -u
MARCH=$1
cd "$(dirname "$0")"
O=out/$MARCH
mkdir -p $O
$CLANG -O2 -Wall -Wextra -c src/harness.c -o $O/harness.o || exit 1
for pad in 0 16 32 48; do
    printf '.text\n.p2align 4\n.skip %s, 0xcc\n' "$pad" > $O/pad$pad.S
    $CLANG -c $O/pad$pad.S -o $O/pad$pad.o || exit 1
done
build_one()
{
    name=$1
    source=$2
    shift 2
    if "$@" -c $source -o $O/k-$name.o 2> $O/k-$name.log; then
        for pad in 0 16 32 48; do
            $CLANG $O/harness.o $O/pad$pad.o $O/k-$name.o -o $O/p$pad-$name -lm || echo "LINK FAILED $name"
            python3 loops.py $O/p$pad-$name > $O/p$pad-$name.loops
        done
        echo "built $name"
    else
        echo "COMPILE FAILED $name: $(head -3 $O/k-$name.log)"
    fi
}
build_one clang-O2 src/kernels.c $CLANG -O2 -march=$MARCH
build_one clang-O2-novec src/kernels.c $CLANG -O2 -march=$MARCH -fno-vectorize -fno-slp-vectorize
build_one clang-O2-novec-nounroll src/kernels.c $CLANG -O2 -march=$MARCH -fno-vectorize -fno-slp-vectorize -fno-unroll-loops
build_one buster-tier1 src/kernels.c $BUSTER --tier1 -O2 -march=$MARCH
build_one buster-tier1-vec src/kernels.c $BUSTER --tier1 --tier1-passes=+vectorize -O2 -march=$MARCH
build_one buster-tier1-vec-scalar src/kernels.c $BUSTER --tier1 --tier1-passes=+vectorize --scalar -O2 -march=$MARCH
build_one main-tier1 src/kernels.c $MAIN --tier1 -O2 -march=$MARCH
build_one main-tier0 src/kernels.c $MAIN -O2 -march=$MARCH
build_one buster-tier0 src/kernels.c $BUSTER -O2 -march=$MARCH
if [ "$MARCH" != x86-64 ]; then
    build_one clang-O2-hand src/kernels_hand.c $CLANG -O2 -march=$MARCH
    build_one buster-tier1-hand src/kernels_hand.c $BUSTER --tier1 -O2 -march=$MARCH
fi
$BUSTER --tier1 --tier1-passes=+vectorize --tier1-report --tier1-refusals -O2 -march=$MARCH -c src/kernels.c -o /dev/null > $O/tier1-report-vec.txt 2>&1
$BUSTER --tier1 --tier1-report --tier1-refusals -O2 -march=$MARCH -c src/kernels.c -o /dev/null > $O/tier1-report.txt 2>&1
sha256sum $O/k-*.o $O/harness.o > $O/sha256.txt
