#!/usr/bin/env bash
# pad.sh MARCH NAME [CPU]: link out/MARCH/k-NAME.o behind 0, 16, 32 and 48 bytes of padding, list each loop's
# placement, and time every kernel at each.
set -u
MARCH=$1
NAME=$2
CPU=${3:-}
cd "$(dirname "$0")"
PIN=""
if [ -n "$CPU" ]; then PIN="taskset -c $CPU"; fi
for pad in 0 16 32 48; do
    printf '.text\n.p2align 4\n.skip %s, 0xcc\n' "$pad" > out/$MARCH/pad$pad.S
    clang -c out/$MARCH/pad$pad.S -o out/$MARCH/pad$pad.o
    clang out/$MARCH/harness.o out/$MARCH/pad$pad.o out/$MARCH/k-$NAME.o -o out/$MARCH/p$pad-$NAME -lm
    python3 loops.py out/$MARCH/p$pad-$NAME > out/$MARCH/p$pad-$NAME.loops
    for k in $(out/$MARCH/p$pad-$NAME list); do
        line=$($PIN out/$MARCH/p$pad-$NAME "$k" 0)
        loop=$(grep "^k_$k " out/$MARCH/p$pad-$NAME.loops)
        echo "$NAME pad$pad $line | $loop"
    done
done
