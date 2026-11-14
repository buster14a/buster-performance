#!/usr/bin/env bash
# run2618d.sh: #2618's rest and #2685 on the 9700X (run2618c.sh with its paths renamed and Release builds), run2618b.sh's measurements (one hold of the lock per round) after
# run2618.sh's builds, each build step one hold: main b7a95eed (BASE) and the pull request's head (HEAD), each compiler
# built in a tree of its own at its commit; Lua 5.4.8's 33 objects by each compiler's --tier1, linked by cc in the same
# six orders as #2618's first part (its orders.txt); speedtest1 as one unity unit at the driver's link. The inputs and
# clang -O0's Lua are the first part's (2618-claude), the inputs' hashes checked.
set -u
W=$HOME/buster-fast-bench/2618d-claude
P=$HOME/buster-fast-bench/2618-claude
export EXCLUSIVE_OWNER=claude-2618 EXCLUSIVE_TITLE='GitHub issue #2618 (rest) and #2685: ties, folded takes, unread recipes' EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQsNkec1N4WJ65hh6VB
L=$HOME/buster-fast-bench/exclusive.sh
BASE=${BASE:?the base commit}
HEAD=${HEAD:?the head commit}
ORDERS=${ORDERS:-6}
ROUNDS=${ROUNDS:-11}
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
IN=$W/inputs
LUA=$IN/lua-5.4.8/src
FILES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
log() { echo "$(date -u +%FT%TZ) $*" >> $W/run.log; }
mkdir -p $W && cd $W || exit 1
echo $$ > rund.pid
[ -d $IN ] || cp -a $P/inputs $IN
[ -x $W/lua-clang0 ] || cp -a $P/lua-clang0 $W/lua-clang0
cp $P/orders.txt $W/orders.txt
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d $SQ/sqlite3.c | sha256sum --check --quiet || { log "sqlite3.c differs"; exit 1; }
(cd $IN && sha256sum --check --quiet inputs.sha256) || { log "inputs differ"; exit 1; }
for t in base head; do
    c=$BASE; [ $t = head ] && c=$HEAD
    if [ ! -x $W/$t/build/compiler ]; then
        rm -rf $W/$t && git init -q $W/$t && git -C $W/$t fetch -q --depth 1 https://github.com/buster14a/buster $c && git -C $W/$t checkout -q FETCH_HEAD || { log "$t fetch failed"; exit 1; }
        $L bash -c "head -1 /var/lib/buster-9700x/owner >> $W/holds.txt; cd $W/$t && BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-$t.log 2>&1"; log "$t $(git -C $W/$t rev-parse HEAD) build exit $?"
    fi
done
[ -x $W/base/build/compiler ] && [ -x $W/head/build/compiler ] || { log "a compiler is missing"; exit 1; }
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > $IN/speedtest1-unity.c
cat > $W/objects.sh <<EOS
set -u
head -1 /var/lib/buster-9700x/owner >> $W/holds.txt
unset CPATH C_INCLUDE_PATH
for t in base head; do
    C=$W/\$t/build/compiler
    mkdir -p $W/obj-\$t
    (cd $W/obj-\$t && for f in $FILES; do \$C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o \$f.o $LUA/\$f.c || exit 1; done) || exit 1
    \$C --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -I$IN -o $W/st-\$t $IN/speedtest1-unity.c -lm || exit 1
done
while read o perm; do
    for t in base head; do
        objs=""; for f in \$perm; do objs="\$objs $W/obj-\$t/\$f.o"; done
        (cd $W && cc -o lua-\$t-o\$o \$objs -lm -ldl) || exit 1
    done
done < $W/orders.txt
EOS
$L bash $W/objects.sh; log "objects and links exit $?"
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
T=/tmp/claude-2618d-compile
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
rm -rf /tmp/claude-2618d-compile
log done
