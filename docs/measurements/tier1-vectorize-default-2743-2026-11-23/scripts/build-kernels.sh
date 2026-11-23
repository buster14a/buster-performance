#!/usr/bin/env bash
# build-kernels.sh MARCH: #2743's kernels by clang -O2, main's --tier1 (BASE) and the branch's (HEAD, the vectorizer on
# by default), with the controls HEAD --tier1-passes=-vectorize and BASE --tier1-passes=+vectorize; each linked with clang
# -O2's harness behind 0, 16, 32 and 48 bytes of padding, and with the short trip counts' harness (short.c) as linked;
# the reports and every object's sha256. Environment: BASE, HEAD, CLANG. Run under the lock.
set -u
MARCH=$1
cd "$(dirname "$0")"
O=out/$MARCH
mkdir -p $O
head -1 /var/lib/buster-9700x/owner >> holds.txt
$CLANG -O2 -Wall -Wextra -c src/harness.c -o $O/harness.o || exit 1
$CLANG -O2 -Wall -Wextra -c src/short.c -o $O/short.o || exit 1
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
        $CLANG $O/short.o $O/k-$name.o -o $O/s-$name -lm || echo "LINK FAILED short $name"
        echo "built $name"
    else
        echo "COMPILE FAILED $name: $(head -3 $O/k-$name.log)"
    fi
}
build_one clang-O2 $CLANG -O2 -march=$MARCH
build_one base-tier1 $BASE --tier1 -O2 -march=$MARCH
build_one head-tier1 $HEAD --tier1 -O2 -march=$MARCH
build_one head-tier1-novec $HEAD --tier1 --tier1-passes=-vectorize -O2 -march=$MARCH
build_one base-tier1-vec $BASE --tier1 --tier1-passes=+vectorize -O2 -march=$MARCH
$HEAD --tier1 --tier1-report --tier1-refusals -O2 -march=$MARCH -c src/kernels.c -o /dev/null > $O/tier1-report-head.txt 2>&1
$BASE --tier1 --tier1-report --tier1-refusals -O2 -march=$MARCH -c src/kernels.c -o /dev/null > $O/tier1-report-base.txt 2>&1
sha256sum $O/k-*.o $O/harness.o $O/short.o > $O/sha256.txt
