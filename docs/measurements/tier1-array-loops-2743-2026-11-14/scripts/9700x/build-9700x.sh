#!/usr/bin/env bash
# build-9700x.sh MARCH: every configuration's kernels, each linked behind 0, 16, 32 and 48 bytes of padding.
# Environment: BUSTER, CLANG, GCC.
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
build_one clang-O0 src/kernels.c $CLANG -O0 -march=$MARCH
build_one clang-O1 src/kernels.c $CLANG -O1 -march=$MARCH
build_one clang-O2-novec-nounroll src/kernels.c $CLANG -O2 -march=$MARCH -fno-vectorize -fno-slp-vectorize -fno-unroll-loops
build_one clang-O2-novec src/kernels.c $CLANG -O2 -march=$MARCH -fno-vectorize -fno-slp-vectorize
build_one clang-O2 src/kernels.c $CLANG -O2 -march=$MARCH
build_one clang-O3 src/kernels.c $CLANG -O3 -march=$MARCH
build_one gcc-O2 src/kernels.c $GCC -O2 -march=$MARCH
build_one gcc-O3 src/kernels.c $GCC -O3 -march=$MARCH
build_one buster-tier0 src/kernels.c $BUSTER -O2 -march=$MARCH
build_one buster-tier1 src/kernels.c $BUSTER --tier1 -O2 -march=$MARCH
build_one buster-tier1-licm src/kernels.c $BUSTER --tier1 --tier1-passes=+licm -O2 -march=$MARCH
build_one buster-tier1-all src/kernels.c $BUSTER --tier1 --tier1-passes=+all -O2 -march=$MARCH
if [ "$MARCH" != x86-64 ]; then
    build_one clang-O2-hand src/kernels_hand.c $CLANG -O2 -march=$MARCH
    build_one buster-tier1-hand src/kernels_hand.c $BUSTER --tier1 -O2 -march=$MARCH
fi
$BUSTER --tier1 --tier1-report --tier1-refusals -O2 -march=$MARCH -c src/kernels.c -o /dev/null > $O/tier1-report.txt 2>&1
if [ "$MARCH" != x86-64 ]; then
    $BUSTER --tier1 --tier1-report --tier1-refusals -O2 -march=$MARCH -c src/kernels_hand.c -o /dev/null > $O/tier1-report-hand.txt 2>&1
fi
sha256sum $O/k-*.o $O/harness.o > $O/sha256.txt
