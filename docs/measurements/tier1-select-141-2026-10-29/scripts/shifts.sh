#!/bin/bash
# The benchmark's unit (tier1_select_benchmark.c, which has its own copies of the selector and the emitter) of main and
# the head at six placements over a page (build.sh shifts, each tree's build in a hold of its own), then three rounds,
# each one hold, of benchmark-tier1-select by every placement of main, the head and main again (the floor), pinned to
# CPU 2, the placements in an order rotating by round and the builds in one alternating by round.
cd "$(dirname "$0")" || exit 1
. ./env.sh
echo $$ > shifts.pid
shifts=(0 704 1408 2112 2816 3520)
mkdir -p $M/shifts
for t in $MAIN $HEAD; do
    echo "== shifts $t $(date -Is)"
    $X bash -c "cd $T/$t && BUSTER_DEBUG_INFO=0 ./build.sh shifts $B/shifts/$t tier1_select_benchmark.c ${shifts[*]}" > $M/shifts-build-$t.log 2>&1 || { echo "shifts $t failed"; tail -5 $M/shifts-build-$t.log; exit 1; }
    tail -2 $M/shifts-build-$t.log
    sha256sum $B/shifts/$t/compiler-* | tee -a $M/receipt.txt
done
for r in 1 2 3; do
    order=()
    for i in 0 1 2 3 4 5; do order+=(${shifts[$(( (i + r) % 6 ))]}); done
    if [ $((r % 2)) = 1 ]; then builds="main:$MAIN head:$HEAD again:$MAIN"; else builds="head:$HEAD again:$MAIN main:$MAIN"; fi
    $X bash -c "for s in ${order[*]}; do for b in $builds; do n=\${b%%:*}; t=\${b#*:}; taskset -c 2 $B/shifts/\$t/compiler-\$s benchmark-tier1-select > $M/shifts/\$n-\$s-$r.log 2>&1; echo \"\$n \$s $r \$?\"; done; done" > $M/shifts/round-$r.log 2>&1
    grep -cE "^(main|head|again) [0-9]+ $r 0$" $M/shifts/round-$r.log | sed "s/^/round $r runs ok: /"
done
echo "shifts done $(date -Is)"
