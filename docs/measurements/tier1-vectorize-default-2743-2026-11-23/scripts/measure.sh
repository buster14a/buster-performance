#!/usr/bin/env bash
# measure.sh: buster#2743's loop vectorizer by default, on the 9700X, detached. Every build, run and compile under its
# own hold of the lock: the branch's Release build (head; main's, base, is built by build-base.sh); #2743's kernels at
# znver5 and x86-64 by clang -O2, main's --tier1 and the branch's at four placements, and at short trip counts as
# linked; sqlite3.c's and main.c's --tier1 compile cost at both targets; speedtest1 and Lua by the branch's
# measure-tier1-programs, the CI's configuration (--check-code-size) with -vectorize as a variant, and at znver5; and
# measure-tier1-rows' vector code against main's --tier1.
set -u
R=~/buster-fast-bench/2743-claude-default
cd $R || exit 1
export EXCLUSIVE_OWNER=claude-2743-default
export EXCLUSIVE_TITLE="buster #2743: Tier 1 loop vectorizer by default"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2743
LOCK=~/buster-fast-bench/exclusive.sh
export CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
export BASE=$R/base/build/compiler
export HEAD=$R/head/build/compiler
SQLITE=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
step() { echo "$(date -u +%FT%TZ) $*" >> $R/progress.txt; }
BUSY='{ echo "$(date -u +%FT%TZ) $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> '$R/busy.txt
rm -f measure.done
step start
[ -x $HEAD ] || { ./build-base.sh head; }
[ -x $HEAD ] || { step "head build failed"; exit 1; }
step built
{
    date -u +%FT%TZ
    uname -a
    $CLANG --version | head -2
    perf --version
    echo "governor cpu2: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    grep -m1 'model name' /proc/cpuinfo
    echo "base: $(git -C base rev-parse HEAD)"
    echo "head: $(git -C head rev-parse HEAD)"
    sha256sum $BASE $HEAD
} > env.txt 2>&1
mkdir -p work/rows
$LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> $R/holds.txt; $BUSY; cd $R/head && PATH=$(dirname $CLANG):\$PATH timeout -k 5 1500 taskset -c 2 ./build/compiler measure-tier1-rows --runs 11 --clang clang --base $BASE --march znver5 --lexer src/buster/compiler/c_lexer.c --directory $R/work/rows" > out/rows.txt 2>&1
echo "exit $?" >> out/rows.txt
step "rows"
cd $R/loops
for MARCH in znver5 x86-64; do
    O=out/$MARCH
    mkdir -p $O
    $LOCK bash -c "$BUSY; timeout -k 5 1200 ./build-kernels.sh $MARCH" > $O/build.log 2>&1
    step "built kernels $MARCH"
done
for MARCH in znver5 x86-64; do
    O=out/$MARCH
    : > $O/results.txt
    for NAME in clang-O2 base-tier1 head-tier1; do
        for PAD in 0 16 32 48; do
            $LOCK bash -c "$BUSY; timeout -k 5 1800 ./run-one.sh $MARCH $NAME $PAD; $BUSY" >> $O/results.txt 2>> $O/run.log
        done
        step "ran $MARCH $NAME"
    done
    : > $O/short.txt
    for NAME in clang-O2 base-tier1 head-tier1; do
        $LOCK bash -c "$BUSY; timeout -k 5 1800 ./run-short.sh $MARCH $NAME; $BUSY" >> $O/short.txt 2>> $O/run.log
    done
    step "ran short $MARCH"
done
mkdir -p out/cost
for MARCH in znver5 x86-64; do
    $LOCK bash -c "$BUSY; timeout -k 5 1800 ./compile-cost.sh sqlite3 11 $MARCH -- -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQLITE -c $SQLITE/sqlite3.c; $BUSY" >> out/cost/results.txt 2>> out/cost/run.log
    $LOCK bash -c "$BUSY; timeout -k 5 1800 ./compile-cost.sh main 11 $MARCH -- -I$R/base/src -fwrapv -funsigned-char -fno-strict-aliasing -c $R/base/src/buster/compiler/main.c; $BUSY" >> out/cost/results.txt 2>> out/cost/run.log
    step "cost $MARCH"
done
cd $R
./programs2.sh head head-x86-64 --tier1-passes=-vectorize
step "programs x86-64"
CHECK= ./programs2.sh head head-znver5 -march=znver5 @$R/inputs/znver5-novec.rsp
step "programs znver5"
step done
echo done > $R/measure.done
