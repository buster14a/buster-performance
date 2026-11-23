#!/usr/bin/env bash
# build-kernels.sh MARCH: #2743's kernels by clang -O2, main's and the branch's --tier1 --tier1-passes=+vectorize, and
# main's --tier1, each linked with clang -O2's harness behind 0, 16, 32 and 48 bytes of padding; the reports and every
# object's sha256. Environment: BUSTER (the branch's Release compiler), MAIN (main's), CLANG. Run under the lock.
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
    shift
    if "$@" -c src/kernels.c -o $O/k-$name.o 2> $O/k-$name.log; then
        for pad in 0 16 32 48; do
            $CLANG $O/harness.o $O/pad$pad.o $O/k-$name.o -o $O/p$pad-$name -lm || echo "LINK FAILED $name"
            python3 loops.py $O/p$pad-$name > $O/p$pad-$name.loops
        done
        echo "built $name"
    else
        echo "COMPILE FAILED $name: $(head -3 $O/k-$name.log)"
    fi
}
build_one clang-O2 $CLANG -O2 -march=$MARCH
build_one main-tier1 $MAIN --tier1 -O2 -march=$MARCH
build_one main-tier1-vec $MAIN --tier1 --tier1-passes=+vectorize -O2 -march=$MARCH
build_one buster-tier1-vec $BUSTER --tier1 --tier1-passes=+vectorize -O2 -march=$MARCH
$BUSTER --tier1 --tier1-passes=+vectorize --tier1-report --tier1-refusals -O2 -march=$MARCH -c src/kernels.c -o /dev/null > $O/tier1-report-vec.txt 2>&1
$MAIN --tier1 --tier1-passes=+vectorize --tier1-report --tier1-refusals -O2 -march=$MARCH -c src/kernels.c -o /dev/null > $O/tier1-report-vec-main.txt 2>&1
sha256sum $O/k-*.o $O/harness.o > $O/sha256.txt
