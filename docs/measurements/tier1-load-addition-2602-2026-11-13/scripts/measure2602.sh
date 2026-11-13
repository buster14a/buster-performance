#!/usr/bin/env bash
# #2602 on the 9700X, after run2602.sh built both compilers, their Lua objects and speedtest1 executables, clang -O0's
# Lua and the first layouts. run2602.sh, compile2602.sh and rerun2602.sh took the lock for every run, and four sessions
# shared it that morning: each hold waited about two minutes, which would have taken a day. This script makes the same
# links, checks and runs, in the same rounds and orders and with the same counters and output files, with fewer holds,
# each under about 10 s: one per build for its six layouts' links; one for every Lua check and one per build for
# speedtest1's; in each round, one per build for its six layouts' five scripts (30 runs) and one for both builds'
# speedtest1; and for each compile (and the /tmp rerun) one per round for both builds. Every run is pinned to CPU 2 with
# perf stat's task-clock, user cycles and user instructions, a file of its own, gathered after the hold.
set -u
W=$HOME/buster-fast-bench/2602-claude
export EXCLUSIVE_OWNER=claude-2602 EXCLUSIVE_TITLE='Solve 2602: an addition of a load from memory' EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxndcswcy5h6cwFvZ4QF
L=$HOME/buster-fast-bench/exclusive.sh
ORDERS=${ORDERS:-6}
ROUNDS=${ROUNDS:-11}
FILES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
log() { echo "$(date -u +%FT%TZ) $*" >> $W/$1.log; }
fields() { awk -F, -v head="$1" 'BEGIN{ORS=""; print head} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' "$2"; }
cd $W || exit 1
echo $$ > measure.pid
for t in base head; do [ -x $W/$t/build/compiler ] && [ -x $W/st-$t ] && [ -f $W/obj-$t/lua.o ] || { log run "$t's builds missing"; exit 1; }; done
# The layouts, as run2602.sh makes them (shuf's random source is the order's number repeated, so they repeat).
: > $W/orders.txt
for o in $(seq 0 $((ORDERS - 1))); do
    if [ $o = 0 ]; then perm="$FILES"; else perm=$(echo $FILES | tr ' ' '\n' | shuf --random-source=<(yes $o) | tr '\n' ' '); fi
    echo "$o $perm" >> $W/orders.txt
done
for t in base head; do
    $L bash -c "cd $W && while read o perm; do objs=''; for f in \$perm; do objs=\"\$objs $W/obj-$t/\$f.o\"; done; cc -o lua-$t-o\$o \$objs -lm -ldl || exit 1; done < orders.txt"
    log run "links $t exit $?"
done
sha256sum $W/obj-*/*.o $W/lua-* $W/st-* > $W/executables.sha256
# The checks: every script by clang -O0 and by every Lua executable, outputs compared after the hold; speedtest1's hash.
$L bash -c "cd $W/inputs && for s in calls tables strings arithmetic closures; do $W/lua-clang0 \$s.lua > $W/ref-\$s.out 2>&1; for o in \$(seq 0 $((ORDERS - 1))); do for t in base head; do $W/lua-\$t-o\$o \$s.lua > $W/check-\$t-o\$o-\$s.out 2>&1; echo \$? > $W/check-\$t-o\$o-\$s.status; done; done; done"
status=0
for s in calls tables strings arithmetic closures; do
    for o in $(seq 0 $((ORDERS - 1))); do
        for t in base head; do
            cmp -s $W/check-$t-o$o-$s.out $W/ref-$s.out && [ "$(cat $W/check-$t-o$o-$s.status)" = 0 ] || { log run "check $s $t o$o FAILED"; status=1; }
        done
    done
done
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
for t in base head; do
    $L bash -c "rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp; cd $W/db && SQLITE_TMPDIR=$W/tmp $W/st-$t $OPTS --verify speedtest1.db > $W/verify-$t.txt 2>&1"
    grep -qx 'Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739' $W/verify-$t.txt || { log run "verify $t FAILED"; status=1; }
done
log run "checks status $status"
[ $status = 0 ] || exit 1
E=task-clock,cycles:u,instructions:u
# Run time: each round, both builds' six layouts in the order run2602.sh used for layout 0 (alternating by round), then
# speedtest1's pair, its database on /home.
: > $W/runs.txt
for round in $(seq 1 $ROUNDS); do
    first=base; second=head
    [ $((round % 2)) = 1 ] && first=head && second=base
    for t in $first $second; do
        $L bash -c "cd $W/inputs && for o in \$(seq 0 $((ORDERS - 1))); do for s in calls tables strings arithmetic closures; do taskset -c 2 perf stat -x, -e $E -o $W/one-$t-o\$o-\$s.txt $W/lua-$t-o\$o \$s.lua > /dev/null 2>&1; done; done"
        for o in $(seq 0 $((ORDERS - 1))); do
            for s in calls tables strings arithmetic closures; do fields "lua $round $o $t $s" $W/one-$t-o$o-$s.txt >> $W/runs.txt; done
        done
    done
    $L bash -c "for t in $first $second; do rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp; cd $W/db && SQLITE_TMPDIR=$W/tmp taskset -c 2 perf stat -x, -e $E -o $W/one-st-\$t.txt $W/st-\$t $OPTS speedtest1.db > /dev/null 2>&1; done"
    for t in $first $second; do fields "st $round 0 $t speedtest1" $W/one-st-$t.txt >> $W/runs.txt; done
    log run "round $round"
done
log run done
# Compile time: the frozen sqlite3.c and Lua's 33 sources, a warm-up pair, then ROUNDS pairs alternating; the outputs
# checked against the first pair's.
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
LUA=$W/inputs/lua-5.4.8/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
LUA_SOURCES=$(for f in $FILES; do printf '%s ' $LUA/$f.c; done)
mkdir -p $W/compiled
: > $W/compile-runs.txt
for what in sqlite lua; do
    for round in 0 $(seq 1 $ROUNDS); do
        first=base; second=head
        [ $((round % 2)) = 1 ] && first=head && second=base
        if [ $what = sqlite ]; then
            body="$W/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -c -o sqlite3-\$t.o $SQ/sqlite3.c"
        else
            body="$W/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-\$t $LUA_SOURCES -lm -ldl"
        fi
        $L bash -c "unset CPATH C_INCLUDE_PATH; cd $W/compiled && for t in $first $second; do taskset -c 2 perf stat -x, -e $E -o $W/one-compile-\$t.txt $body > /dev/null 2>&1; done"
        phase=run; [ $round = 0 ] && phase=warmup
        for t in $first $second; do fields "$phase $round $t $what" $W/one-compile-$t.txt >> $W/compile-runs.txt; done
        [ $round = 0 ] && sha256sum $W/compiled/sqlite3-*.o $W/compiled/lua-* 2> /dev/null > $W/compiled-first.sha256
    done
    sha256sum $W/compiled/sqlite3-*.o $W/compiled/lua-* 2> /dev/null | cmp -s - $W/compiled-first.sha256 && log compile "$what outputs stable" || log compile "$what outputs CHANGED"
    log compile "$what done"
done
log compile done
# speedtest1 again with its database and SQLite's temporary files in /tmp (tmpfs): a warm-up pair, then ROUNDS pairs.
T=/tmp/claude-2602-st
: > $W/st-tmp-runs.txt
for round in 0 $(seq 1 $ROUNDS); do
    first=base; second=head
    [ $((round % 2)) = 1 ] && first=head && second=base
    $L bash -c "for t in $first $second; do rm -rf $T; mkdir -p $T/db $T/tmp; cd $T/db && SQLITE_TMPDIR=$T/tmp taskset -c 2 perf stat -x, -e $E -o $W/one-st-\$t.txt $W/st-\$t $OPTS speedtest1.db > /dev/null 2>&1; done; rm -rf $T"
    kind=st; [ $round = 0 ] && kind=warmup
    for t in $first $second; do fields "$kind $round 0 $t speedtest1" $W/one-st-$t.txt >> $W/st-tmp-runs.txt; done
done
log rerun "speedtest1 in /tmp done"
log rerun done
