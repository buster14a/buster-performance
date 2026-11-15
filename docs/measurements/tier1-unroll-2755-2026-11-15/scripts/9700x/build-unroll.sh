#!/usr/bin/env bash
# build-unroll.sh MARCH: the kernels by each build (clang -O2 with and without its vectorizer and unroller, Tier 1 at the
# base, Tier 1 at the head with its default pipeline and with --tier1-passes=+unroll), each linked behind 0, 16, 32 and
# 48 bytes of padding. Environment: BASE, HEAD (the two compilers), CLANG. Run under the lock.
set -u
MARCH=$1
cd "$(dirname "$0")"
O=out/$MARCH
mkdir -p $O
head -1 /var/lib/buster-9700x/owner >> holds.txt
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
build_one tier1-base src/kernels.c $BASE --tier1 -O2 -march=$MARCH
build_one tier1-head src/kernels.c $HEAD --tier1 -O2 -march=$MARCH
build_one tier1-unroll src/kernels.c $HEAD --tier1 --tier1-passes=+unroll -O2 -march=$MARCH
$HEAD --tier1 --tier1-report --tier1-refusals --tier1-passes=+unroll -O2 -march=$MARCH -c src/kernels.c -o /dev/null > $O/tier1-report-unroll.txt 2>&1
$BASE --tier1 --tier1-report --tier1-refusals -O2 -march=$MARCH -c src/kernels.c -o /dev/null > $O/tier1-report-base.txt 2>&1
if cmp -s $O/k-tier1-base.o $O/k-tier1-head.o; then echo "tier1 objects: base and head (default pipeline) identical"; else echo "tier1 objects: base and head DIFFER"; fi
size $O/k-tier1-base.o $O/k-tier1-unroll.o $O/k-clang-O2-novec.o $O/k-clang-O2-novec-nounroll.o > $O/sizes.txt
sha256sum $O/k-*.o $O/harness.o > $O/sha256.txt
