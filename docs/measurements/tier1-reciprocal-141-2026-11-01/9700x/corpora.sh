#!/usr/bin/env bash
# corpora.sh HEAD: #141's Done-when on the corpora's programs, by HEAD's build, on the 9700X, every step one hold of the
# shared lock, every compile and run pinned to CPU 2; outputs in corpora-HEAD/.
#  1. Lua 5.4.8's interpreter (lua.c and the library, as its Makefile's linux target builds them: -std=gnu99
#     -DLUA_COMPAT_5_3 -DLUA_USE_LINUX, -lm -ldl; tcc without -std=gnu99) built by head's Tier 0, --tier1 and
#     --tier1 --scalar, clang -O0, clang -O2 and tcc; each of lua/'s five original scripts run by each build, whose
#     outputs must be clang -O0's; 11 rounds of every build and script, the builds in an order rotating by round, a round
#     one hold; perf stat of each build's runs.
#  2. c-testsuite's subset (220 programs) built by the same six compilers, each program run against its expected output
#     (standard output and errors, status 0); perf stat of each run, and of an empty program's by each compiler; the
#     instructions of the programs' own functions (clang -O0's object's defined functions) in each executable; 5 rounds
#     of every program's run by each build, rotating, a round one hold.
#  3. speedtest1 (#136's harness) built by the same six, a --verify run of each, 11 rounds of the six in a rotating order,
#     each run one hold, from a fresh database on tmpfs; perf stat of one run each.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
head=$1
B=$PWD/$head/build/compiler
out=$PWD/corpora-$head
LUA=$PWD/inputs/lua-5.4.8/src
mkdir -p $out/lua $out/cts $out/st
compilers=(t0 t1 t1s clang0 clang2 tcc)
# The compile command of each compiler: buster's options and clang's -O, or tcc.
cc_of() { # compiler
    case $1 in
        t0) echo "$B" ;;
        t1) echo "$B --tier1 -fno-asynchronous-unwind-tables" ;;
        t1s) echo "$B --tier1 --scalar -fno-asynchronous-unwind-tables" ;;
        clang0) echo "clang -O0" ;;
        clang2) echo "clang -O2" ;;
        tcc) echo "tcc" ;;
    esac
}
# 1. Lua.
lua_files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    lua_files="$lua_files $LUA/$f.c"
done
cp lua/*.lua $out/lua/
for c in ${compilers[@]}; do
    std=$([ $c = tcc ] || echo -std=gnu99)
    report=$([ "${c#t1}" != "$c" ] && echo --tier1-report)
    "$lock" bash -c "cd $out/lua && taskset -c 2 $(cc_of $c) $report $std -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$c $lua_files -lm -ldl > build-$c.txt 2>&1; echo \"exit \$?\" >> build-$c.txt"
done
scripts=(calls tables strings arithmetic closures)
"$lock" bash -c "cd $out/lua && for s in ${scripts[*]}; do for c in ${compilers[*]}; do [ -x lua-\$c ] && taskset -c 2 ./lua-\$c \$s.lua > \$s-\$c.out 2>&1; echo \"\$s \$c \$?\" >> status.txt; done; done"
"$lock" bash -c "cd $out/lua && for s in ${scripts[*]}; do for c in ${compilers[*]}; do echo \"\$s \$c \$(cmp \$s-clang0.out \$s-\$c.out > /dev/null 2>&1 && echo same || echo differs)\"; done; done > compare.txt"
"$lock" bash -c "mkdir -p $out/lua/objects && cd $out/lua/objects && for f in $lua_files; do clang -std=gnu99 -O0 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o \$(basename \$f .c).o \$f && nm --defined-only \$(basename \$f .c).o | awk '\$2 ~ /^[Tt]\$/ { print \$3 }'; done | LC_ALL=C sort -u > ../functions.txt; cd .. && bash $PWD/classes.sh lua-t0 lua-t1 > classes.txt && awk -F'\t' '\$2 == \"tier1\" { print \$1 }' classes.txt > tier1-functions.txt && for c in ${compilers[*]}; do [ -x lua-\$c ] && echo \"\$c \$(objdump -d --no-show-raw-insn lua-\$c | awk -v list=functions.txt -f $PWD/static.awk) \$(objdump -d --no-show-raw-insn lua-\$c | awk -v list=tier1-functions.txt -f $PWD/static.awk)\"; done > static.txt"
cat > $out/lua/round.sh <<'ROUND'
#!/usr/bin/env bash
# round.sh ROUND: every build's run of every script, the builds in an order rotating by ROUND; a line per run: the round,
# the script, the build and the microseconds from before the run's fork to after its wait.
cd "$(dirname "$0")"
compilers=(t0 t1 t1s clang0 clang2 tcc)
for s in calls tables strings arithmetic closures; do
    for i in 0 1 2 3 4 5; do
        c=${compilers[$(( ($1 + i) % 6 ))]}
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
for c in ${compilers[@]}; do
    [ -x $out/lua/lua-$c ] || continue
    "$lock" bash -c "cd $out/lua && for s in ${scripts[*]}; do taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o stat-\$s-$c.txt -- ./lua-$c \$s.lua > /dev/null 2>&1; done"
done
# 2. c-testsuite.
tests=$(sed -n 's|^\([0-9][0-9]*\)$|\1|p' $head/tests/c-testsuite/subset.txt)
echo "$tests" > $out/cts/tests.txt
printf 'int main(void)\n{\n    return 0;\n}\n' > $out/cts/empty.c
for c in ${compilers[@]}; do
    mkdir -p $out/cts/bin-$c
    "$lock" bash -c "cd $out/cts && for n in $(echo $tests); do taskset -c 2 $(cc_of $c) -o bin-$c/\$n $CTS/tests/single-exec/\$n.c -lm > bin-$c/\$n.build 2>&1; echo \"\$n \$?\" >> build-$c.txt; done; taskset -c 2 $(cc_of $c) -o bin-$c/empty empty.c > bin-$c/empty.build 2>&1"
done
"$lock" bash -c "mkdir -p $out/cts/objects && cd $out/cts/objects && for n in $(echo $tests); do clang -O0 -c -o \$n.o $CTS/tests/single-exec/\$n.c > /dev/null 2>&1; nm --defined-only \$n.o | awk '\$2 ~ /^[Tt]\$/ { print \$3 }' > \$n.functions; done"
cat > $out/cts/check.sh <<'CHECK'
#!/usr/bin/env bash
# check.sh COMPILER CTS: each of COMPILER's programs run in a directory of its own with standard input from /dev/null,
# against its expected output (standard output and errors) and status 0; then perf stat's user-space instructions of a
# run of each, and of the empty program. A line per program in check-COMPILER.txt and stat-COMPILER.txt.
cd "$(dirname "$0")"
c=$1
: > check-$c.txt
: > stat-$c.txt
for n in $(cat tests.txt) empty; do
    rm -rf run && mkdir run
    if [ -x bin-$c/$n ]; then
        (cd run && timeout 10 taskset -c 2 ../bin-$c/$n < /dev/null > ../out 2>&1)
        status=$?
        if [ $n = empty ]; then
            result=$([ $status = 0 ] && echo pass || echo "fail status $status")
        elif [ $status != 0 ]; then
            result="fail status $status"
        elif cmp -s out $2/tests/single-exec/$n.c.expected; then
            result=pass
        else
            result="fail output"
        fi
        rm -rf run && mkdir run
        (cd run && timeout 10 taskset -c 2 perf stat -x, -e instructions:u -o ../stat.out -- ../bin-$c/$n < /dev/null > /dev/null 2>&1)
        echo "$n $(awk -F, '/instructions/ { print $1 }' stat.out)" >> stat-$c.txt
    else
        result="no executable"
    fi
    echo "$n $result" >> check-$c.txt
done
rm -rf run out stat.out
CHECK
chmod +x $out/cts/check.sh
for c in ${compilers[@]}; do
    "$lock" bash -c "$out/cts/check.sh $c $CTS"
done
cat > $out/cts/round.sh <<'ROUND'
#!/usr/bin/env bash
# round.sh ROUND: every program's run by every build, the builds in an order rotating by ROUND and program; a line per
# run: the round, the program, the build and the microseconds from before its fork to after its wait.
cd "$(dirname "$0")"
compilers=(t0 t1 t1s clang0 clang2 tcc)
k=$1
mkdir -p run
for n in $(cat tests.txt) empty; do
    for i in 0 1 2 3 4 5; do
        c=${compilers[$(( (k + i) % 6 ))]}
        [ -x bin-$c/$n ] || continue
        start=$EPOCHREALTIME
        (cd run && taskset -c 2 ../bin-$c/$n < /dev/null > /dev/null 2>&1)
        end=$EPOCHREALTIME
        echo "$1 $n $c $(( ${end/./} - ${start/./} ))"
    done
    k=$(( k + 1 ))
done
rm -rf run
ROUND
chmod +x $out/cts/round.sh
: > $out/cts/times.txt
for r in $(seq 0 4); do
    "$lock" bash -c "$out/cts/round.sh $r >> $out/cts/times.txt"
done
cat > $out/cts/static.sh <<'STATIC'
#!/usr/bin/env bash
# static.sh AWK: each build's programs' own functions' instructions (static.awk), a line per program in static-BUILD.txt.
cd "$(dirname "$0")"
for c in t0 t1 t1s clang0 clang2 tcc; do
    for n in $(cat tests.txt); do
        [ -x bin-$c/$n ] && echo "$n $(objdump -d --no-show-raw-insn bin-$c/$n | awk -v list=objects/$n.functions -f $1)"
    done > static-$c.txt
done
STATIC
chmod +x $out/cts/static.sh
"$lock" bash -c "$out/cts/static.sh $PWD/static.awk"
# 3. speedtest1.
st=$out/st
for c in ${compilers[@]}; do
    case $c in
        clang0|clang2) cmd="$(cc_of $c) -c $FLAGS -I$Q -o $c-sqlite3.o $Q/sqlite3.c && $(cc_of $c) -c $FLAGS -I$Q -o $c-speedtest1.o $SRC/speedtest1.c && cc -o st-$c $c-speedtest1.o $c-sqlite3.o -lm" ;;
        *) cmd="$(cc_of $c) $FLAGS -I$Q -o st-$c $SRC/speedtest1-unity.c -lm" ;;
    esac
    "$lock" bash -c "cd $st && taskset -c 2 $cmd > build-$c.txt 2>&1; echo \"exit \$?\" >> build-$c.txt"
done
run() { # build output [speedtest1 options...]
    rm -rf $RUNDIR/run
    mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp
    local s e
    TIMEFORMAT='%3U %3S'
    s=$EPOCHREALTIME
    { time (cd $RUNDIR/run/db && SQLITE_TMPDIR=$RUNDIR/run/tmp taskset -c 2 $st/st-$1 $OPTS "${@:3}" speedtest1.db > $2 2>&1) ; } 2> $2.time
    e=$EPOCHREALTIME
    echo "$(( ${e/./} - ${s/./} )) $(cat $2.time)"
}
export -f run
export st RUNDIR OPTS
for c in ${compilers[@]}; do
    [ -x $st/st-$c ] && "$lock" bash -c "run $c $st/verify-$c.txt --verify > /dev/null"
done
: > $st/run.times
for r in $(seq 0 10); do
    for i in $(seq 0 5); do
        c=${compilers[$(( (r + i) % 6 ))]}
        [ -x $st/st-$c ] || continue
        o=$st/r$r-$c.txt
        line=$("$lock" bash -c "run $c $o")
        echo "$r $c $line $(awk '/TOTAL/ {print $2}' $o)" >> $st/run.times
    done
done
for c in ${compilers[@]}; do
    [ -x $st/st-$c ] && "$lock" bash -c "rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=../tmp taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o $st/stat-$c.txt -- $st/st-$c $OPTS speedtest1.db > /dev/null 2>&1"
done
"$lock" bash -c "for c in ${compilers[*]}; do [ -x $st/st-\$c ] && objdump -d --no-show-raw-insn $st/st-\$c | awk -f $PWD/count.awk > $st/count-\$c.txt; done"
echo done > $out/done
