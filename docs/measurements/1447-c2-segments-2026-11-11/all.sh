#!/bin/bash
# #1447 package C2 on the 9700X: -c of sqlite3.c and main.c (the base1 tree's, the same input for every build) by each
# PR's head and its base. Every build and run takes the shared lock on its own; ab takes it per run.
cd "$(dirname "$0")" || exit 1
export LC_ALL=C
B=$HOME/buster-fast-bench/1447-c2-claude
T=$B/trees
M=$B/m
export EXCLUSIVE_OWNER=claude-1447-c2
export EXCLUSIVE_TITLE="#1447 C2: segment leftovers, base-vs-head -c of sqlite3.c and main.c"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxne1qKEHRFYAFpAFjC8
X=$HOME/buster-fast-bench/exclusive.sh
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
SQLITE=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$CORPUS/sqlite" "$CORPUS/sqlite/sqlite3.c")
MAINC=(-c -march=native "-I$T/base1/src" -fwrapv -funsigned-char -fno-strict-aliasing "$T/base1/src/buster/compiler/main.c")
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
TREES="base1 pr2106 pr2118 base3 pr2123"
{
    echo "== $(date -Is)"; uname -a; grep -m1 "model name" /proc/cpuinfo
    echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor)"; clang --version | head -n 1
    for t in $TREES; do echo "tree $t commit $(cat $T/$t/COMMIT)"; done
} > $M/receipt.txt 2>&1
for t in $TREES; do
    echo "== build $t $(date -Is)"
    $X bash -c "cd $T/$t && BUSTER_DEBUG_INFO=0 ./build.sh" > $M/build-$t.log 2>&1 || { echo "build $t failed"; tail -5 $M/build-$t.log; exit 1; }
    sha256sum $T/$t/build/compiler | tee -a $M/receipt.txt
done
for t in $TREES; do
    $X bash -c "taskset -c 2 $T/$t/build/compiler -o $M/sqlite-$t.o $(printf '%q ' "${SQLITE[@]}"); echo $t sqlite exit \$?; taskset -c 2 $T/$t/build/compiler -o $M/main-$t.o $(printf '%q ' "${MAINC[@]}"); echo $t main exit \$?" >> $M/compile.log 2>&1
done
cat $M/compile.log
sha256sum $M/*.o | tee $M/objects.sha256
echo "== ab $(date -Is)"
$T/base3/build/compiler ab --rounds 15 --cpu 2 --lock $X $(for t in $TREES; do printf '%s ' $T/$t; done) -- -o /tmp/1447-c2-sqlite.o "${SQLITE[@]}" -- -o /tmp/1447-c2-main.o "${MAINC[@]}" > $M/ab.txt 2>&1
echo "ab exit $?"
tail -40 $M/ab.txt
echo "all done $(date -Is)"
