#!/bin/bash
# record.sh: buster#3344's 9700X run (#2608's setcc threading). Trees: base = main 1b9821a, head = the PR merged with
# it. Both Release builds. Lua 5.4.8's 33 units compiled once per tree (--tier1 -fno-asynchronous-unwind-tables
# -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX), each tree's fixed objects linked by clang in 33 orders recorded before
# any timing (order 0 the Makefile's, 1 to 32 shuffled by Python's Random(2608)), the same orders for both trees. Every
# executable's output for #138's five scripts must be clang -O0's. Then three rounds of perf stat (3 runs, user
# counters, CPU 2) over every (order, tree, script), the trees' order alternating by order and round; then perf record
# (cycles:u, fixed period) of the five scripts by every executable, for luaV_execute's own cycles; then the compile
# cost: lvm.c's and sqlite3.c's --tier1 -c, one lane, 11 alternating runs a tree. Every step is one exclusive.sh hold,
# whose first act appends the holder's line to record/holds.txt.
set -uo pipefail
D=~/buster-fast-bench/2608-3344-claude
cd $D
R=$D/record
W=$D/work
mkdir -p $R $W
rm -f $R/record.done $R/record.failed
export EXCLUSIVE_OWNER=claude-2608-3344 EXCLUSIVE_TITLE="PR 3344 merge-ready (setcc threading, #2608)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3344
X=~/buster-fast-bench/exclusive.sh
IN=~/buster-fast-bench/138-tier1-quality-claude/inputs
LUA=$IN/lua-5.4.8/src
SQL=~/buster-fast-bench/2608-claude/harness/sqlite3.c
UNITS="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
SCRIPTS="arithmetic calls closures strings tables"
FLAGS="-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
export D R W IN LUA SQL UNITS SCRIPTS FLAGS
log() { echo "$(date -u +%FT%TZ) $*" >> $R/steps.log; }
fail() { log "FAILED: $*"; echo "$*" > $R/record.failed; exit 1; }
HOLD='head -1 /var/lib/buster-9700x/owner >> $R/holds.txt;'
python3 -I -c '
import random, sys
units = sys.argv[1].split()
rng = random.Random(2608)
print(" ".join(units))
for k in range(32):
    order = units[:]
    rng.shuffle(order)
    print(" ".join(order))
' "$UNITS" > $R/orders.txt
for t in base head; do
    if [ ! -x $D/$t/build/compiler ]; then
        "$X" bash -c "$HOLD cd $D/$t && BUSTER_DEBUG_INFO=0 ./build.sh --config Release" > $R/build-$t.log 2>&1
        log "build $t exit $?"
    fi
    test -x $D/$t/build/compiler || fail "no $t compiler"
done
"$X" bash -c "$HOLD"'
set -e
for t in base head; do
    mkdir -p $W/obj-$t
    for u in $UNITS; do $D/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables $FLAGS -c -o $W/obj-$t/$u.o $LUA/$u.c; done
done
srcs=""; for u in $UNITS; do srcs="$srcs $LUA/$u.c"; done
clang -O0 $FLAGS -o $W/lua-clang0 $srcs -lm -ldl
k=0
while read -r order; do
    for t in base head; do
        objs=""; for u in $order; do objs="$objs $W/obj-$t/$u.o"; done
        clang -o $W/lua-$t-$k $objs -lm -ldl
    done
    k=$((k + 1))
done < $R/orders.txt
' > $R/objects.log 2>&1 || fail "objects or link"
log "objects and links done"
(cd $W && sha256sum obj-*/*.o lua-*) > $R/binaries.sha256
"$X" bash -c "$HOLD"'
cd /tmp
for s in $SCRIPTS; do $W/lua-clang0 $IN/scripts/$s.lua > $W/ref-$s.txt 2>&1; echo "status $?" >> $W/ref-$s.txt; done
for k in $(seq 0 32); do for t in base head; do for s in $SCRIPTS; do
    $W/lua-$t-$k $IN/scripts/$s.lua > $W/out.txt 2>&1; echo "status $?" >> $W/out.txt
    cmp -s $W/out.txt $W/ref-$s.txt && echo "$t $k $s same" || echo "$t $k $s DIFFERS"
done; done; done
rm -f $W/out.txt
' > $R/outputs.txt 2>&1
log "outputs: $(grep -c same $R/outputs.txt) same, $(grep -c DIFFERS $R/outputs.txt) differ"
grep -q DIFFERS $R/outputs.txt && fail "outputs differ"
cp $W/ref-*.txt $R/
{
    date -u +%FT%TZ; uname -a; clang --version | head -1; perf --version
    for f in scaling_governor energy_performance_preference; do printf 'cpu2 %s: %s\n' $f "$(cat /sys/devices/system/cpu/cpu2/cpufreq/$f)"; done
    for t in base head; do printf '%s: ' $t; git -C $D/$t log -1 --format=%H; git -C $D/$t status --short | wc -l; sha256sum $D/$t/build/compiler; done
    sha256sum $0 $SQL $IN/scripts/*.lua
} > $R/receipts.txt
for round in 1 2 3; do
    "$X" bash -c "$HOLD"'
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | sed "s/^/# round $0 /" >> $R/busy.txt
cd /tmp
for k in $(seq 0 32); do
    if [ $(( (k + $0) % 2 )) = 0 ]; then trees="base head"; else trees="head base"; fi
    for t in $trees; do for s in $SCRIPTS; do
        printf "%s\t%s\t%s\t%s\t" $0 $k $t $s
        perf stat -x, -r 3 -e cycles:u,instructions:u,task-clock taskset -c 2 $W/lua-$t-$k $IN/scripts/$s.lua 2>&1 >/dev/null | awk -F, "{printf \"%s=%s\t\", \$3, \$1} END {print \"\"}"
    done; done
done
' $round >> $R/runs.tsv 2>&1
    log "round $round exit $?"
done
"$X" bash -c "$HOLD"'
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | sed "s/^/# profile /" >> $R/busy.txt
cd /tmp
for k in $(seq 0 32); do for t in base head; do
    perf record -q -e cycles:u -c 100003 -o $W/p.data -- taskset -c 2 sh -c "for s in $SCRIPTS; do $W/lua-$t-$k $IN/scripts/\$s.lua; done" > /dev/null 2>&1
    perf report -i $W/p.data --stdio -n --sort sym 2>/dev/null | awk -v t=$t -v k=$k "/^#/ || NF == 0 {next} {total += \$2} /luaV_execute/ {lv += \$2} END {printf \"%s\t%s\tluaV_execute=%d\ttotal=%d\tperiod=100003\n\", t, k, lv, total}"
done; done
rm -f $W/p.data
' > $R/profile.tsv 2>&1
log "profile exit $?"
"$X" bash -c "$HOLD"'
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | sed "s/^/# cost /" >> $R/busy.txt
for r in $(seq 11); do for t in base head; do
    printf "%s\t%s\tlvm\t" $t $r
    perf stat -x, -e cycles:u,instructions:u,task-clock taskset -c 2 $D/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables --lanes 1 $FLAGS -c $LUA/lvm.c -o /tmp/3344-claude-lvm.o 2>&1 >/dev/null | awk -F, "{printf \"%s=%s\t\", \$3, \$1} END {print \"\"}"
    printf "%s\t%s\tsqlite\t" $t $r
    perf stat -x, -e cycles:u,instructions:u,task-clock taskset -c 2 $D/$t/build/compiler --tier1 -O2 --lanes 1 -c $SQL -o /tmp/3344-claude-sqlite.o 2>&1 >/dev/null | awk -F, "{printf \"%s=%s\t\", \$3, \$1} END {print \"\"}"
done; done
rm -f /tmp/3344-claude-lvm.o /tmp/3344-claude-sqlite.o
' > $R/cost.tsv 2>&1
log "cost exit $?"
echo done > $R/record.done
