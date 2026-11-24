#!/bin/bash
# The UBSan build of the head and the checker's, the driver's and the corpus's checks under it.
cd /home/user/buster || exit 1
L=/home/user/logs/ubsan; rm -rf $L; mkdir -p $L
BUSTER_SANITIZER=undefined ./build.sh --config Release > $L/build.log 2>&1; echo "exit $?" >> $L/build.log
cp build/compiler /home/user/bin/compiler-ubsan
C=/home/user/bin/compiler-ubsan
$C test-checker --seed 133 > $L/checker.log 2>&1; echo "exit $?" >> $L/checker.log
for k in 1 2 3 4; do ($C test-checker-driver --executable $C --part $k/4 --in-process > $L/driver-$k.log 2>&1; echo "exit $?" >> $L/driver-$k.log) & done; wait
S=/home/user/corpus/sqlite
for w in "" "-Wall -Wextra"; do
    BUSTER_TEST_DEFAULT_PATH_LOG=$L/visits.log $C --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $w $S/sqlite3.c -o $L/sqlite-v.o >> $L/sqlite.log 2>&1; echo "exit $?" >> $L/sqlite.log
    $C --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $w $S/sqlite3.c -o $L/sqlite.o >> $L/sqlite.log 2>&1; echo "exit $?" >> $L/sqlite.log
    cmp $L/sqlite.o $L/sqlite-v.o >> $L/sqlite.log 2>&1; echo "cmp $?" >> $L/sqlite.log
done
$C test-checker-corpus --seed 133 /home/user/c-testsuite/tests/single-exec > $L/corpus.log 2>&1; echo "exit $?" >> $L/corpus.log
cp /home/user/bin/compiler-final build/compiler
echo done > $L/complete
