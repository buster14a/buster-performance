#!/bin/bash
# #1447 package C2b on the 9700X: the SS template set (claude/segment-ss-encoder) against its base: the baked table,
# benchmark-x86-encoder, and -c of sqlite3.c and main.c (the base tree's, the same input for both). Every build and run
# takes the shared lock on its own; ab takes it per run.
cd "$(dirname "$0")" || exit 1
export LC_ALL=C
B=$HOME/buster-fast-bench/1447-c2b-claude
T=$B/trees
M=$B/m
export EXCLUSIVE_OWNER=claude-1447-c2b
export EXCLUSIVE_TITLE="#1447 C2b: %ss template set, base-vs-head encoder and -c of sqlite3.c and main.c"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxneLXDfHzfe48SLceHE
X=$HOME/buster-fast-bench/exclusive.sh
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
SQLITE=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$CORPUS/sqlite" "$CORPUS/sqlite/sqlite3.c")
MAINC=(-c -march=native "-I$T/base/src" -fwrapv -funsigned-char -fno-strict-aliasing "$T/base/src/buster/compiler/main.c")
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
TREES="${TREES:-base ss}"
{
    echo "== $(date -Is)"; uname -a; grep -m1 "model name" /proc/cpuinfo
    echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor)"; clang --version | head -n 1
    for t in $TREES; do echo "tree $t commit $(cat $T/$t/COMMIT)"; done
} > $M/receipt.txt 2>&1
if [ -z "$SKIP_BUILD" ]; then
for t in $TREES; do
    echo "== build $t $(date -Is)"
    $X bash -c "cd $T/$t && BUSTER_DEBUG_INFO=0 ./build.sh" > $M/build-$t.log 2>&1 || { echo "build $t failed"; tail -5 $M/build-$t.log; exit 1; }
    sha256sum $T/$t/build/compiler | tee -a $M/receipt.txt
    ls -l $T/$t/build/compiler | tee -a $M/receipt.txt
done
fi
for t in $TREES; do
    $X bash -c "cd $T/$t && taskset -c 2 ./build/compiler test-baked-tables; taskset -c 2 ./build/compiler test-x86-encoder > /dev/null; echo $t test-x86-encoder exit \$?" >> $M/tests.log 2>&1
done
cat $M/tests.log
: > $M/compile.log
for t in $TREES; do
    $X bash -c "taskset -c 2 $T/$t/build/compiler -o $M/sqlite-$t.o $(printf '%q ' "${SQLITE[@]}"); echo $t sqlite exit \$?; taskset -c 2 $T/$t/build/compiler -o $M/main-$t.o $(printf '%q ' "${MAINC[@]}"); echo $t main exit \$?" >> $M/compile.log 2>&1
done
cat $M/compile.log
sha256sum $M/*.o | tee $M/objects.sha256
echo "== benchmark-x86-encoder $(date -Is)"
: > $M/encoder.txt
for round in 1 2 3; do
    for t in $TREES; do
        echo "-- $t round $round" >> $M/encoder.txt
        $X bash -c "cd $T/$t && taskset -c 2 ./build/compiler benchmark-x86-encoder" >> $M/encoder.txt 2>&1
    done
done
echo "== ab $(date -Is)"
$T/ss/build/compiler ab --rounds 15 --cpu 2 --lock $X $(for t in $TREES; do printf '%s ' $T/$t; done) -- -o /tmp/1447-c2b-sqlite.o "${SQLITE[@]}" -- -o /tmp/1447-c2b-main.o "${MAINC[@]}" > $M/ab.txt 2>&1
echo "ab exit $?"
tail -40 $M/ab.txt
echo "all done $(date -Is)"
