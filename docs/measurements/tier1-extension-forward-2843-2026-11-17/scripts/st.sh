#!/usr/bin/env bash
# st.sh COMPILER DIR: speedtest1 as one unit by COMPILER --tier1 (#136's flags), its --verify hash, and a callgrind
# run of #2767's options.
set -u
C=$HOME/.cache/claude-2843
B=$1; d=$(readlink -f $2); mkdir -p $d
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > $d/unity.c
$B --tier1 -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/corpus/sqlite -I$C/S/inputs -o $d/st $d/unity.c || exit 1
opts="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
rm -rf $d/db $d/tmp; mkdir -p $d/tmp
SQLITE_TMPDIR=$d/tmp $d/st --verify $opts $d/db 2>&1 | grep -i 'verif' > $d/verify.txt
rm -rf $d/db $d/tmp; mkdir -p $d/tmp
SQLITE_TMPDIR=$d/tmp valgrind --tool=callgrind --callgrind-out-file=$d/st.cg $d/st $opts $d/db > $d/st.out 2> $d/st.err
echo "$(cat $d/verify.txt) | callgrind $(grep -m1 '^summary' $d/st.cg | cut -d' ' -f2)"
