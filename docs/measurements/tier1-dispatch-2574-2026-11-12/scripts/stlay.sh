#!/bin/bash
# Run B's speedtest1 objects linked by cc at six layouts: a pad of N bytes of int3 in .text before the unit's code
# (N = 0 adds no pad object), the same for both builds. Each executable's verification hash is checked, then eleven
# rounds, the builds' order rotating by round and layout, each run one hold of the lock, pinned to CPU 2, perf stat's
# task-clock, user cycles and user instructions (lay/runs.txt, the analyze.py format with the pad as the layout).
W=$HOME/buster-fast-bench/2574-claude-b
D=$W/lay
L=$HOME/buster-fast-bench/exclusive.sh
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
E=task-clock,cycles:u,instructions:u
PADS="0 16 32 48 1072 3088"
export EXCLUSIVE_OWNER=claude-2574 EXCLUSIVE_TITLE="#2574 disptab: speedtest1 layouts" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2591
cd $D || exit 1
for n in $PADS; do
    pad=""
    if [ $n != 0 ]; then
        printf '.text\n.globl buster_pad_%d\nbuster_pad_%d:\n.skip %d, 0xcc\n.section .note.GNU-stack,"",@progbits\n' $n $n $n > pad-$n.s
        cc -c -o pad-$n.o pad-$n.s || exit 1
        pad=$D/pad-$n.o
    fi
    for t in base head; do
        $L bash -c "cd $D && cc -o st-$t-p$n $pad st-$t.o -lm" || { echo "link $t $n failed"; exit 1; }
        $L bash -c "rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp; cd $W/db && SQLITE_TMPDIR=$W/tmp $D/st-$t-p$n $OPTS --verify speedtest1.db > $D/verify-$t-p$n.txt 2>&1"
        grep -qx 'Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739' $D/verify-$t-p$n.txt || { echo "verify $t $n FAILED"; exit 1; }
        nm st-$t-p$n | grep -E ' (sqlite3VdbeExec|sqlite3BtreeIndexMoveto|sqlite3RunParser)$' | tr '\n' ' '; echo " $t p$n"
    done
done
sha256sum st-*.o st-*-p* pad-*.o > executables.sha256
: > runs.txt
o=0
for round in $(seq 1 11); do
    o=0
    for n in $PADS; do
        first=base; second=head
        [ $(( (round + o) % 2 )) = 1 ] && first=head && second=base
        for t in $first $second; do
            $L bash -c "rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp; cd $W/db && SQLITE_TMPDIR=$W/tmp taskset -c 2 perf stat -x, -e $E -o $D/one.txt $D/st-$t-p$n $OPTS speedtest1.db > /dev/null 2>&1"
            awk -F, -v r=$round -v o=$o -v t=$t 'BEGIN{ORS=""; print "st", r, o, t, "speedtest1"} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $D/one.txt >> runs.txt
        done
        o=$((o + 1))
    done
done
echo done
