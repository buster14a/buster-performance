#!/usr/bin/env bash
# programs.sh BASE HEAD: on the 9700X, every compile and run pinned to CPU 2, each step one hold of the shared lock, a
# round of short runs one hold; outputs in programs-HEAD/.
#  1. Each tree's --tier1-report and --tier1-refusals of the frozen sqlite3.c (one hold).
#  2. --tier1 -c of the frozen sqlite3.c: ab of time-runs, 5 rounds of 21 runs (ab holds the lock per run of time-runs);
#     perf stat, 11 runs of each tree a hold, the trees alternating, 3 holds.
#  3. speedtest1 built by base's and head's --tier1 and head's Tier 0 (one hold); a --verify run of each (one hold);
#     11 rounds of the three in a rotating order, each from a fresh database on tmpfs, a round one hold; perf stat of one
#     run each (one hold).
. ~/buster-fast-bench/1116-claude/common.sh
base=$1
head=$2
out=$PWD/programs-$head
mkdir -p $out/reports $out/st
"$lock" bash -c "cd $RUNDIR && for t in $base $head; do taskset -c 2 $PWD/\$t/build/compiler --tier1 --tier1-report --tier1-refusals -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/report-\$t.o $Q/sqlite3.c > $out/reports/sqlite3-\$t.txt 2>&1; echo \"exit \$?\" >> $out/reports/sqlite3-\$t.txt; done"
$head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-t1.o $Q/sqlite3.c > $out/compile-tier1-ab.log 2>&1
echo "exit $?" >> $out/compile-tier1-ab.log
for r in 1 2 3; do
    "$lock" bash -c "for t in $base $head; do taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $out/compile-stat-\$t-$r.csv $PWD/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/perf-\$t.o $Q/sqlite3.c; echo \"exit \$?\" >> $out/compile-stat-\$t-$r.csv; done"
done
st=$out/st
"$lock" bash -c "cd $st && taskset -c 2 $PWD/$base/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1base $SRC/speedtest1-unity.c -lm > build-t1base.txt 2>&1; echo \"exit \$?\" >> build-t1base.txt; taskset -c 2 $PWD/$head/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1 $SRC/speedtest1-unity.c -lm > build-t1.txt 2>&1; echo \"exit \$?\" >> build-t1.txt; taskset -c 2 $PWD/$head/build/compiler $FLAGS -I$Q -o st-t0 $SRC/speedtest1-unity.c -lm > build-t0.txt 2>&1; echo \"exit \$?\" >> build-t0.txt"
builds=(t1base t1 t0)
cat > $st/run.sh <<RUN
#!/usr/bin/env bash
# run.sh BUILD OUTPUT [speedtest1 options...]: one run of st-BUILD from a fresh database on tmpfs; prints the
# microseconds from before its fork to after its wait, and its exit status.
rm -rf $RUNDIR/run
mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp
s=\$EPOCHREALTIME
(cd $RUNDIR/run/db && SQLITE_TMPDIR=$RUNDIR/run/tmp taskset -c 2 $st/st-\$1 $OPTS "\${@:3}" speedtest1.db > \$2 2>&1)
status=\$?
e=\$EPOCHREALTIME
echo "\$(( \${e/./} - \${s/./} )) \$status"
RUN
chmod +x $st/run.sh
"$lock" bash -c "for c in ${builds[*]}; do [ -x $st/st-\$c ] && $st/run.sh \$c $st/verify-\$c.txt --verify > $st/verify-\$c.status; done"
: > $st/run.times
for r in $(seq 0 10); do
    order=""
    for i in 0 1 2; do order="$order ${builds[$(( (r + i) % 3 ))]}"; done
    "$lock" bash -c "for c in $order; do [ -x $st/st-\$c ] || continue; o=$st/r$r-\$c.txt; echo \"$r \$c \$($st/run.sh \$c \$o) \$(awk '/TOTAL/ {print \$2}' \$o)\" >> $st/run.times; done"
done
"$lock" bash -c "for c in ${builds[*]}; do rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=../tmp perf stat -x, -e instructions:u,cycles:u,branches:u,branch-misses:u -o $st/stat-\$c.txt -- taskset -c 2 $st/st-\$c $OPTS speedtest1.db > /dev/null 2>&1; echo \"exit \$?\" >> $st/stat-\$c.txt; done"
echo done > $out/done
