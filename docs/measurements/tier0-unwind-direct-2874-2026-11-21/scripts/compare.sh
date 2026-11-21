#!/bin/bash
# Usage: compare.sh BASE NEW OUTDIR: compile each corpus with both binaries and compare objects, diagnostics and exits.
set -u
BASE=$1; NEW=$2; OUT=$3
S=/tmp/claude-0/-home-user/da9b228d-448f-5dff-bcec-738df11c230d/scratchpad
mkdir -p $OUT
# one job line: TAG SOURCE FLAGS...
jobs=$OUT/jobs.txt
: > $jobs
SQ="$(cat $S/sqlite-flags.txt)"
MU="$(cat $S/musl-flags.txt)"
echo "sqlite-plain /home/user/corpus/sqlite/sqlite3.c $SQ" >> $jobs
echo "sqlite-g /home/user/corpus/sqlite/sqlite3.c $SQ -g" >> $jobs
n=0
while read -r f; do
    n=$((n+1)); echo "musl-$n $f $MU -funwind-tables" >> $jobs
    echo "muslg-$n $f $MU -funwind-tables -g" >> $jobs
done < $S/musl-units.txt
n=0
for f in $(cd /home/user/buster && find tests -name "*.c" | sort); do
    n=$((n+1)); echo "tests-$n /home/user/buster/$f -march=znver5" >> $jobs
    echo "testsg-$n /home/user/buster/$f -march=znver5 -g -O0" >> $jobs
done
if [ -d /home/user/buster/build/c-testsuite/tests/single-exec ]; then
    n=0
    for f in /home/user/buster/build/c-testsuite/tests/single-exec/*.c; do
        n=$((n+1)); echo "cts-$n $f -march=znver5" >> $jobs
        echo "ctsg-$n $f -march=znver5 -g" >> $jobs
    done
fi
run_one() {
    BASE=$1; NEW=$2; OUT=$3; shift 3
    tag=$1; src=$2; shift 2
    d=$OUT/w/$tag; mkdir -p $d
    (cd $d && $BASE -c "$@" -o base.o "$src" > base.out 2> base.err; echo $? > base.exit)
    (cd $d && $NEW -c "$@" -o new.o "$src" > new.out 2> new.err; echo $? > new.exit)
    same=1
    cmp -s $d/base.exit $d/new.exit || same=0
    cmp -s $d/base.err $d/new.err || same=0
    if [ -f $d/base.o ] || [ -f $d/new.o ]; then cmp -s $d/base.o $d/new.o || same=0; fi
    eh=0; [ -f $d/new.o ] && readelf -S $d/new.o 2>/dev/null | grep -q eh_frame && eh=1
    if [ $same = 1 ]; then echo "SAME $tag exit=$(cat $d/base.exit) eh=$eh"; rm -rf $d; else echo "DIFF $tag $src $*"; fi
}
export -f run_one
xargs -P ${JOBS:-4} -L 1 bash -c 'run_one "$0" "$1" "$2" $3 $4 ${@:5}' $BASE $NEW $OUT < $jobs > $OUT/results.txt 2>&1
echo "jobs $(wc -l < $jobs) same $(grep -c '^SAME' $OUT/results.txt) diff $(grep -c '^DIFF' $OUT/results.txt) with-eh $(grep -c 'eh=1' $OUT/results.txt) ok-exit $(grep -c 'exit=0' $OUT/results.txt)"
