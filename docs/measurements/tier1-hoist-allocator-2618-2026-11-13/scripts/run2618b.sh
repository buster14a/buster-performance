#!/usr/bin/env bash
# run2618b.sh: #2618's run-time and compile-time comparison on the 9700X, by run2618.sh's (#2593's run2593.sh's)
# measurements, with one hold of the lock per round rather than per run. run2618.sh built both compilers, Lua's objects
# and its six link orders' executables, speedtest1 at the driver's link and clang -O0's Lua, each step one hold, and was
# then stopped: under the day's contention each hold waited three to nine minutes, and its 900 holds would have taken
# days. This script reuses those files (their hashes in executables.sha256) and holds the lock:
# - once to build speedtest1's layouts (each compiler's unity unit as one object, linked after a pad of N bytes);
# - once for every check: each Lua executable's five scripts against clang -O0's outputs, and every speedtest1
#   executable's verification hash;
# - once per round, ROUNDS rounds after a warm-up round 0: every order's two Lua builds on all five scripts, speedtest1's
#   two builds at the driver's link, its two builds at each of six layouts, and the two compilers' --tier1 -c of
#   sqlite3.c and --tier1 of Lua's 33 sources, the builds' order rotating by round and by order or layout as in
#   run2618.sh, each process one perf stat of task-clock, user cycles and user instructions, pinned to CPU 2.
# A round's processes take about 9 s. Each hold first appends the owner file's first line, its own, to holds.txt.
set -u
W=$HOME/buster-fast-bench/2618-claude
export EXCLUSIVE_OWNER=claude-2618 EXCLUSIVE_TITLE='Problem 2618: hoisted addresses and the allocator' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2636
L=$HOME/buster-fast-bench/exclusive.sh
ORDERS=${ORDERS:-6}
ROUNDS=${ROUNDS:-11}
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
IN=$W/inputs
LUA=$IN/lua-5.4.8/src
FILES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
log() { echo "$(date -u +%FT%TZ) $*" >> $W/run.log; }
cd $W || exit 1
echo $$ > runb.pid
for f in base/build/compiler head/build/compiler obj-base/lua.o obj-head/lua.o st-base st-head lua-clang0; do [ -e $W/$f ] || { log "missing $f"; exit 1; }; done
for o in $(seq 0 $((ORDERS - 1))); do for t in base head; do [ -x $W/lua-$t-o$o ] || { log "missing lua-$t-o$o"; exit 1; }; done; done
sha256sum $W/base/build/compiler $W/head/build/compiler > $W/compilers.sha256
git -C $W/base rev-parse HEAD >> $W/compilers.sha256
git -C $W/head rev-parse HEAD >> $W/compilers.sha256
sha256sum $W/obj-*/*.o $W/lua-* $W/st-base $W/st-head > $W/executables.sha256
{ uname -a; perf --version; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null; cc --version | head -1; } > $W/host.txt 2>&1
# The layouts, as run2618.sh would have made them.
D=$W/lay
PADS="0 16 32 48 1072 3088"
mkdir -p $D
cat > $W/build-layouts.sh <<EOS
set -u
head -1 /var/lib/buster-9700x/owner >> $W/holds.txt
unset CPATH C_INCLUDE_PATH
for t in base head; do
    $W/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -I$IN -c -o $D/st-\$t.o $IN/speedtest1-unity.c || exit 1
done
for n in $PADS; do
    pad=""
    if [ \$n != 0 ]; then
        printf '.text\n.globl buster_pad_%d\nbuster_pad_%d:\n.skip %d, 0xcc\n.section .note.GNU-stack,"",@progbits\n' \$n \$n \$n > $D/pad-\$n.s
        cc -c -o $D/pad-\$n.o $D/pad-\$n.s || exit 1
        pad=$D/pad-\$n.o
    fi
    for t in base head; do
        (cd $D && cc -o st-\$t-p\$n \$pad st-\$t.o -lm) || exit 1
    done
done
EOS
$L bash $W/build-layouts.sh; log "layouts built exit $?"
sha256sum $D/st-*.o $D/st-*-p* $D/pad-*.o > $D/executables.sha256
# The checks.
cat > $W/checks.sh <<EOS
set -u
head -1 /var/lib/buster-9700x/owner >> $W/holds.txt
status=0
for s in calls tables strings arithmetic closures; do
    (cd $IN && $W/lua-clang0 \$s.lua > $W/ref-\$s.out 2>&1)
    for o in \$(seq 0 $((ORDERS - 1))); do
        for t in base head; do
            (cd $IN && $W/lua-\$t-o\$o \$s.lua > $W/check.out 2>&1); rc=\$?
            if cmp -s $W/check.out $W/ref-\$s.out && [ \$rc = 0 ]; then echo "check \$s \$t o\$o same"; else echo "check \$s \$t o\$o FAILED"; status=1; fi
        done
    done
done
for e in $W/st-base $W/st-head $D/st-base-p0 $D/st-head-p0 $D/st-base-p16 $D/st-head-p16 $D/st-base-p32 $D/st-head-p32 $D/st-base-p48 $D/st-head-p48 $D/st-base-p1072 $D/st-head-p1072 $D/st-base-p3088 $D/st-head-p3088; do
    rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp
    (cd $W/db && SQLITE_TMPDIR=$W/tmp \$e --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 --verify speedtest1.db > $W/verify.out 2>&1)
    if grep -qx 'Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739' $W/verify.out; then echo "verify \$e same"; else echo "verify \$e FAILED"; status=1; fi
done
exit \$status
EOS
$L bash $W/checks.sh > $W/checks.txt 2>&1; status=$?
log "checks status $status"
[ $status = 0 ] || exit 1
# The rounds: round 0 the warm-up, its compile outputs the reference for every later round's.
cat > $W/round.sh <<'EOS'
set -u
W=$1; round=$2; ORDERS=$3; SQ=$4; IN=$5; LUA=$6; FLAGS=$7; FILES=$8
head -1 /var/lib/buster-9700x/owner >> $W/holds.txt
E=task-clock,cycles:u,instructions:u
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
D=$W/lay
T=/tmp/claude-2618-compile
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
EOS
: > $W/runs.txt
: > $D/runs.txt
: > $W/compile-runs.txt
for round in $(seq 0 $ROUNDS); do
    $L bash $W/round.sh $W $round $ORDERS $SQ $IN $LUA "$FLAGS" "$FILES"; log "round $round exit $?"
    cmp -s $W/compile-$round.sha256 $W/compile-0.sha256 || log "round $round compile outputs CHANGED"
done
rm -rf /tmp/claude-2618-compile
log done
