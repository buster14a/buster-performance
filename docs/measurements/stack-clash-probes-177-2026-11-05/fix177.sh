#!/usr/bin/env bash
# fix177.sh: #1434's review fix (head.bundle over main) on the 9700X's vector path, each step one hold of the lock: the
# stack-clash part of test-checker-driver with the fixed compiler and, the same test binary's, with the pre-fix one
# (42ad48b6, built in 177-probes-verify) as --executable, which its tail fixture must fail; the core suites; and
# sqlite3.c's default objects by both tiers against main's (e7d3fc79, built in 177-probes-main).
set -u
L="env EXCLUSIVE_OWNER=claude-177-probes EXCLUSIVE_TITLE=Problems_141_177_789 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1434 $HOME/buster-fast-bench/exclusive.sh"
W=$HOME/buster-fast-bench/177-probes-fix
V=$HOME/buster-fast-bench/177-probes-verify
M=$HOME/buster-fast-bench/177-probes-main
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
cd $W || exit 1
out=$W/results.txt
: > $out
if [ ! -d src ]; then git clone -q https://github.com/buster14a/buster src; fi
(cd src && git fetch -q origin main && git fetch -q ../head.bundle HEAD && git checkout -q -f FETCH_HEAD && git log -1 --format='head %H') >> $out 2>&1
(cd $V/src && git log -1 --format='pre-fix %H') >> $out 2>&1
(cd $M/src && git log -1 --format='main %H') >> $out 2>&1
$L bash -c "cd $W/src && ./build.sh > $W/build.log 2>&1"; echo "build $?" >> $out
$L bash -c "cd $W/src && ./build/compiler test-checker-driver --executable ./build/compiler --part 11/64 > $W/part11-fixed.log 2>&1"
echo "part 11 fixed exit=$? $(tail -1 $W/part11-fixed.log)" >> $out
$L bash -c "cd $W/src && ./build/compiler test-checker-driver --executable $V/src/build/compiler --part 11/64 > $W/part11-prefix.log 2>&1"
echo "part 11 with the pre-fix compiler exit=$? $(tail -1 $W/part11-prefix.log)" >> $out
grep "^test-checker:" $W/part11-prefix.log | sort | uniq -c | cut -c1-170 >> $out
for suite in "test-tier0 --cross-check" "test-emitted-code --cross-check" "test-tier1-frame" "test-tier1-frame-execution" "test-tier1-cfg" "test-unwind"; do
    name=$(echo $suite | cut -d' ' -f1)
    $L bash -c "cd $W/src && ./build/compiler $suite > $W/$name.log 2>&1"
    echo "$suite exit=$? $(tail -1 $W/$name.log | cut -c1-150)" >> $out
done
mkdir -p $W/identity && cd $W/identity
$L bash -c "for t in head main; do c=\$([ \$t = head ] && echo $W/src/build/compiler || echo $M/src/build/compiler); \$c -c $FLAGS -I$Q -o t0-\$t.o $Q/sqlite3.c 2>/dev/null; \$c --tier1 -c $FLAGS -I$Q -o t1-\$t.o $Q/sqlite3.c 2>/dev/null; done"
for t in t0 t1; do cmp -s $t-head.o $t-main.o && echo "$t same as main" >> $out || echo "$t DIFFERS from main" >> $out; done
echo done >> $out
