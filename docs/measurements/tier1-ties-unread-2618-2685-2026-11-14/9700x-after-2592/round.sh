set -u
W=$1; round=$2; ORDERS=$3; SQ=$4; IN=$5; LUA=$6; FLAGS=$7; FILES=$8
head -1 /var/lib/buster-9700x/owner >> $W/holds.txt
E=task-clock,cycles:u,instructions:u
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
D=$W/lay
T=/tmp/claude-2618e-compile
mkdir -p $T
# Round 0, the warm-up, records its runs apart.
RUNS=$W/runs.txt; LAYRUNS=$D/runs.txt
[ $round = 0 ] && RUNS=$W/warmup-runs.txt && LAYRUNS=$D/warmup-runs.txt
record() { awk -F, -v head="$2" -v rc=$3 'BEGIN{ORS=""; print head} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print " status=" rc "\n"}' $W/one.txt >> $1; }
for o in $(seq 0 $((ORDERS - 1))); do
    first=base; second=head
    [ $(( (round + o) % 2 )) = 1 ] && first=head && second=base
    for t in $first $second; do
        for s in calls tables strings arithmetic closures; do
            (cd $IN && taskset -c 2 perf stat -x, -e $E -o $W/one.txt $W/lua-$t-o$o $s.lua > /dev/null 2>&1); rc=$?
            record $RUNS "lua $round $o $t $s" $rc
        done
    done
done
first=base; second=head
[ $((round % 2)) = 1 ] && first=head && second=base
for t in $first $second; do
    rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp
    (cd $W/db && SQLITE_TMPDIR=$W/tmp taskset -c 2 perf stat -x, -e $E -o $W/one.txt $W/st-$t $OPTS speedtest1.db > /dev/null 2>&1); rc=$?
    record $RUNS "st $round 0 $t speedtest1" $rc
done
o=0
for n in 0 16 32 48 1072 3088; do
    first=base; second=head
    [ $(( (round + o) % 2 )) = 1 ] && first=head && second=base
    for t in $first $second; do
        rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp
        (cd $W/db && SQLITE_TMPDIR=$W/tmp taskset -c 2 perf stat -x, -e $E -o $W/one.txt $D/st-$t-p$n $OPTS speedtest1.db > /dev/null 2>&1); rc=$?
        record $LAYRUNS "st $round $o $t speedtest1" $rc
    done
    o=$((o + 1))
done
phase=run; [ $round = 0 ] && phase=warmup
unset CPATH C_INCLUDE_PATH
LUA_SOURCES=$(for f in $FILES; do printf '%s ' $LUA/$f.c; done)
for what in sqlite lua; do
    for t in $first $second; do
        C=$W/$t/build/compiler
        if [ $what = sqlite ]; then
            (cd $T && taskset -c 2 perf stat -x, -e $E -o $W/one.txt $C --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -c -o sqlite3-$t.o $SQ/sqlite3.c > /dev/null 2>&1); rc=$?
        else
            (cd $T && taskset -c 2 perf stat -x, -e $E -o $W/one.txt $C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$t $LUA_SOURCES -lm -ldl > /dev/null 2>&1); rc=$?
        fi
        record $W/compile-runs.txt "$phase $round $t $what" $rc
    done
done
(cd $T && sha256sum sqlite3-*.o lua-*) > $W/compile-$round.sha256
