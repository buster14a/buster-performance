#!/usr/bin/env bash
# programs.sh BASE HEAD: #789's labels against main, on the 9700X, every step one hold of the shared lock, every compile
# and run pinned to CPU 2; outputs in programs-HEAD/.
#  1. Each tree's --tier1-report and --tier1-refusals of the frozen sqlite3.c and of Lua 5.4.8's sources.
#  2. --tier1 -c of the frozen sqlite3.c: ab of time-runs, 5 rounds of 21 runs, and perf stat, 11 runs a hold, 3 holds.
#  3. speedtest1 (#136's harness) built by base's and head's --tier1 and head's Tier 0; a --verify run of each; 11 rounds
#     of the three in a rotating order, each from a fresh database on tmpfs; perf stat of one run each.
#  4. Lua's interpreter built by base's and head's --tier1 and clang -O0; each of the five scripts by each build, whose
#     outputs must be clang -O0's; 11 rounds, the builds in a rotating order, a round one hold; perf stat of each run.
. ~/buster-fast-bench/claude-141-remaining/common.sh
base=$1
head=$2
out=$PWD/programs-$head
mkdir -p $out/reports $out/st $out/lua
lua_files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    lua_files="$lua_files $LUA/$f.c"
done
# 1.
for t in $base $head; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 $PWD/$t/build/compiler --tier1 --tier1-report --tier1-refusals -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/report-$t.o $Q/sqlite3.c > $out/reports/sqlite3-$t.txt 2>&1"
    "$lock" bash -c "cd $RUNDIR && for f in $lua_files; do taskset -c 2 $PWD/$t/build/compiler --tier1 --tier1-report --tier1-refusals -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $RUNDIR/report-lua.o \$f; done > $out/reports/lua-$t.txt 2>&1"
done
# 2.
$head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-t1.o $Q/sqlite3.c > $out/compile-tier1-ab.log 2>&1
echo "exit $?" >> $out/compile-tier1-ab.log
for r in 1 2 3; do
    for t in $base $head; do
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $out/compile-stat-$t-$r.csv $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/perf-$t.o $Q/sqlite3.c"
    done
done
# 3.
st=$out/st
build() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $st && taskset -c 2 $* > $st/build-$n.txt 2>&1; echo \"exit \$?\" >> $st/build-$n.txt"
}
build t1base $PWD/$base/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1base $SRC/speedtest1-unity.c -lm
build t1 $PWD/$head/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1 $SRC/speedtest1-unity.c -lm
build t0 $PWD/$head/build/compiler $FLAGS -I$Q -o st-t0 $SRC/speedtest1-unity.c -lm
builds=(t1base t1 t0)
run() { # build output [speedtest1 options...]
    rm -rf $RUNDIR/run
    mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp
    local s e
    s=$EPOCHREALTIME
    (cd $RUNDIR/run/db && SQLITE_TMPDIR=$RUNDIR/run/tmp taskset -c 2 $st/st-$1 $OPTS "${@:3}" speedtest1.db > $2 2>&1)
    e=$EPOCHREALTIME
    echo "$(( ${e/./} - ${s/./} ))"
}
export -f run
export st RUNDIR OPTS
for c in ${builds[@]}; do
    [ -x $st/st-$c ] && "$lock" bash -c "run $c $st/verify-$c.txt --verify > /dev/null"
done
: > $st/run.times
for r in $(seq 0 10); do
    for i in 0 1 2; do
        c=${builds[$(( (r + i) % 3 ))]}
        [ -x $st/st-$c ] || continue
        o=$st/r$r-$c.txt
        line=$("$lock" bash -c "run $c $o")
        echo "$r $c $line $(awk '/TOTAL/ {print $2}' $o)" >> $st/run.times
    done
done
for c in ${builds[@]}; do
    "$lock" bash -c "rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=../tmp perf stat -x, -e instructions:u,cycles:u,branches:u,branch-misses:u -o $st/stat-$c.txt -- taskset -c 2 $st/st-$c $OPTS speedtest1.db > /dev/null 2>&1"
done
# 4.
cp $LUA_SCRIPTS/*.lua $out/lua/
for c in t1base t1 clang0; do
    case $c in
        t1base) cc="$PWD/$base/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables" ;;
        t1) cc="$PWD/$head/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables" ;;
        clang0) cc="clang -O0" ;;
    esac
    "$lock" bash -c "cd $out/lua && taskset -c 2 $cc -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$c $lua_files -lm -ldl > build-$c.txt 2>&1; echo \"exit \$?\" >> build-$c.txt"
done
scripts=(calls tables strings arithmetic closures)
"$lock" bash -c "cd $out/lua && for s in ${scripts[*]}; do for c in t1base t1 clang0; do [ -x lua-\$c ] && taskset -c 2 ./lua-\$c \$s.lua > \$s-\$c.out 2>&1; echo \"\$s \$c \$?\" >> status.txt; done; done"
"$lock" bash -c "cd $out/lua && for s in ${scripts[*]}; do for c in t1base t1; do echo \"\$s \$c \$(cmp \$s-clang0.out \$s-\$c.out > /dev/null 2>&1 && echo same || echo differs)\"; done; done > compare.txt"
cat > $out/lua/round.sh <<'ROUND'
#!/usr/bin/env bash
# round.sh ROUND: each build's run of every script, the builds in an order rotating by ROUND; a line per run: the round,
# the script, the build and the microseconds from before the run's fork to after its wait.
cd "$(dirname "$0")"
compilers=(t1base t1)
for s in calls tables strings arithmetic closures; do
    for i in 0 1; do
        c=${compilers[$(( ($1 + i) % 2 ))]}
        [ -x lua-$c ] || continue
        start=$EPOCHREALTIME
        taskset -c 2 ./lua-$c $s.lua > /dev/null 2>&1
        end=$EPOCHREALTIME
        echo "$1 $s $c $(( ${end/./} - ${start/./} ))"
    done
done
ROUND
chmod +x $out/lua/round.sh
: > $out/lua/times.txt
for r in $(seq 0 10); do
    "$lock" bash -c "$out/lua/round.sh $r >> $out/lua/times.txt"
done
for c in t1base t1; do
    "$lock" bash -c "cd $out/lua && for s in ${scripts[*]}; do taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o stat-\$s-$c.txt -- ./lua-$c \$s.lua > /dev/null 2>&1; done"
done
echo done > $out/done
