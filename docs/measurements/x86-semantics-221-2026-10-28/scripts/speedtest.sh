#!/bin/bash
# speedtest1 built by head and by nosub (each one's -c objects of sqlite3.c and speedtest1.c, linked by cc), on CPU 2:
# the run time of the form choice's substitutions (the choices that change the instruction sequence). One hold builds
# both, checks their verification hashes and records sizes and hashes; then three holds of five rounds each, every
# round a fresh database on tmpfs for each build in an order alternating by round; then one hold of perf stat.
. "$(dirname "$0")/env.sh"
S=$M/speedtest
mkdir -p $S
export S
build() {
    for t in head nosub; do
        taskset -c 2 $T/$t/build/compiler -c $FLAGS -I$Q -o $S/$t-sqlite3.o $Q/sqlite3.c &&
            taskset -c 2 $T/$t/build/compiler -c $FLAGS -I$Q -o $S/$t-speedtest1.o $SRC/speedtest1.c &&
            cc -o $S/st-$t $S/$t-speedtest1.o $S/$t-sqlite3.o -lm || { echo "$t's speedtest1 didn't build"; return 1; }
    done
    size $S/*.o $S/st-* > $S/sizes.txt
    sha256sum $S/*.o $S/st-* > $S/hashes.txt
    for t in head nosub; do
        run $t $S/verify-$t.txt --verify > $S/verify-$t.time
        grep 'Verification Hash' $S/verify-$t.txt
    done
}
run() { # build output [options...] -> wall microseconds
    rm -rf $RUNDIR && mkdir -p $RUNDIR/db $RUNDIR/tmp
    local s=$EPOCHREALTIME
    (cd $RUNDIR/db && SQLITE_TMPDIR=$RUNDIR/tmp taskset -c 2 $S/st-$1 $OPTS "${@:3}" speedtest1.db > $2 2>&1)
    local e=$EPOCHREALTIME
    echo "$(( ${e/./} - ${s/./} ))"
}
rounds() { # first last
    for r in $(seq $1 $2); do
        local order="head nosub"
        [ $((r % 2)) -eq 0 ] && order="nosub head"
        for t in $order; do
            echo "$t $r $(run $t $S/out-$t.txt)" >> $S/runs.txt
        done
    done
}
counts() {
    for t in head nosub; do
        rm -rf $RUNDIR && mkdir -p $RUNDIR/db $RUNDIR/tmp
        (cd $RUNDIR/db && SQLITE_TMPDIR=$RUNDIR/tmp taskset -c 2 perf stat -x, -e task-clock,cycles:u,instructions:u -o $S/perf-$t.csv $S/st-$t $OPTS speedtest1.db > /dev/null 2>&1)
    done
}
export -f build run rounds counts
$X bash -c ". $B/env.sh; build" || exit 1
: > $S/runs.txt
for range in "1 5" "6 10" "11 15"; do
    $X bash -c ". $B/env.sh; rounds $range"
done
$X bash -c ". $B/env.sh; counts"
echo "speedtest done $(date -Is)"
