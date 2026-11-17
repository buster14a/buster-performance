#!/bin/bash
# job-knob.sh: the commit's code (files-fin.patch, with fin's start order) with its asks' threshold read from the
# environment (files-knob.patch: BUSTER_ASKS, 0 for never), so that ONE executable, one copy of it, compiles with its
# asks never made and with them made at a component's third, fourth or fifth miss: the layout, the page cache's state
# and the environment's size are the same on both sides of every comparison (ab.sh's SAME, A_ENV and B_ENV).
#   unit-cost-knob  musl units' own counters (perf stat -r 400), kernel and user, by BUSTER_ASKS=0, 3 and 5, and each
#                   unit's stat calls by strace
#   abk-*           BUSTER_ASKS=0 against 3, 4, 5 and 0 again, on musl's units a process each (11 rounds) and on
#                   hello.c (41 rounds)
cd "$(dirname "$0")"
main=2d817432864947a0853abd1e79879b0086fbd9b7
: > job-knob.done
log=knob.log
: > "$log"
./build-tree.sh knob $main files-fin.patch order-fin.patch files-knob.patch > build-knob.out 2>&1
tail -2 build-knob.out >> "$log"
./lock.sh timeout -k 10 900 ./unit-cost-knob.sh results/unit-cost-knob >> "$log" 2>&1
echo "$? unit-cost-knob" >> "$log"
for spec in musl:11:3 musl:11:0 musl:11:5 musl:11:4 hello:41:3 hello:41:0 hello:41:5 hello:41:4 musl:11:3:again musl:11:0:again musl:11:5:again hello:41:3:again; do
    IFS=: read -r kind rounds asks again <<< "$spec"
    label=$kind-0-$asks${again:+-$again}
    start=$(date +%s)
    SAME=1 A_ENV=BUSTER_ASKS=0 B_ENV=BUSTER_ASKS=$asks ./lock.sh timeout -k 10 900 ./ab.sh "results/abk-$label" "$kind" "$rounds" "off=$PWD/knob/build/compiler" "at$asks=$PWD/knob/build/compiler" > "results/abk-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abk-$label" off "at$asks" > "results/abstatk-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-knob.done
