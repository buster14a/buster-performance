#!/bin/bash
# Where synth's link by one lane with -w (no common warnings) takes 6% more cycles at main than at #763 for 1.2% more
# instructions: perf stat's TLB, cache and fault counters, and perf record of user cycles, by each tree, on CPU 2,
# with main's one lane also without the board; then the same counters for synth's units as processes; one hold.
# Usage: stalls.sh TREE BASE
. $(dirname $0)/common.sh
TREE=${1:?tree}
BASE=${2:?base tree}
OUT=$W/stalls-$TREE
rm -rf $OUT && mkdir -p $OUT/$TREE $OUT/$BASE $OUT/noboard && cd $OUT
syn=$(ls $HOME/buster-fast-bench/units-152-claude/explore/synth/unit_*.c | tr '\n' ' ')
EV=cycles:u,instructions:u,page-faults,ls_l1_d_tlb_miss.all,ls_l1_d_tlb_miss.tlb_reload_4k_l2_miss,ls_l1_d_tlb_miss.tlb_reload_2m_l2_miss,ls_l1_d_tlb_miss.tlb_reload_4k_l2_hit,ls_l1_d_tlb_miss.tlb_reload_2m_l2_hit,l1-dcache-load-misses,cache-misses
cat > hold.sh <<EOS
for T in $TREE $BASE; do
    C=$W/\$T/build/compiler
    cd $OUT/\$T
    echo "== \$T: synth -w --lanes 1 -c, perf stat -r 3"
    perf stat -r 3 -e $EV taskset -c 2 \$C -w --lanes 1 -c $syn 2>&1 | grep -vE '^$|Performance counter'
    perf record -q -e cycles:u -c 1000003 -o perf.data taskset -c 2 \$C -w --lanes 1 -c $syn > /dev/null 2>&1; echo record status \$?
    echo "== \$T: synth -w -c as processes, perf stat -r 1"
    perf stat -e $EV bash -c 'for u in $syn; do taskset -c 2 '\$C' -w -c \$u || exit 1; done' 2>&1 | grep -vE '^$|Performance counter'
done
cd $OUT/noboard
echo "== $TREE without the board: synth -w --lanes 1 -c, perf stat -r 3"
BUSTER_TEST_NO_UNITS_BOARD=1 perf stat -r 3 -e $EV taskset -c 2 $W/$TREE/build/compiler -w --lanes 1 -c $syn 2>&1 | grep -vE '^$|Performance counter'
EOS
lock bash hold.sh
for T in $TREE $BASE; do
    perf report -i $T/perf.data --sort symbol --stdio --no-children 2> /dev/null | grep -v '^#' | grep -v '^$' | head -70 > $T/report.txt
    echo "== $T: the top symbols by user cycles"; head -45 $T/report.txt
done
echo stalls-finished
