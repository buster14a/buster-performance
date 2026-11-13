#!/usr/bin/env bash
# count.sh COMPILER NAME (run as count2.sh in the container): speedtest1 by COMPILER's --tier1, under callgrind, into st-NAME.*; then its dynamic rip leas
# by symbol, indexed-free and indexed, and totals (gap.c's GAP_INSTRUCTIONS rows).
set -eu
G=/root/.cache/claude-2573/gap; IN=/root/.cache/claude-2573/inputs; SQ=/root/.cache/claude-2573/corpus/sqlite
C=$1; t=$2
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
(unset CPATH C_INCLUDE_PATH; $C --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -I$IN -o $G/st-$t $IN/speedtest1-unity.c -lm)
objdump -d --no-show-raw-insn $G/st-$t > $G/st-$t.dis
mkdir $G/db-$t $G/tmp-$t
(cd $G/db-$t && SQLITE_TMPDIR=$G/tmp-$t valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$G/cg-$t.out $G/st-$t $OPTS speedtest1.db > $G/out-$t.txt 2> $G/vg-$t.txt)
mkdir $G/vdb-$t $G/vtmp-$t && (cd $G/vdb-$t && SQLITE_TMPDIR=$G/vtmp-$t $G/st-$t $OPTS --verify speedtest1.db | grep "Verification Hash")
GAP_INSTRUCTIONS=1 $G/gap count $G/st-$t.dis $G/cg-$t.out '???' 0x108000 > $G/st-$t.tsv
grep "I   refs" $G/vg-$t.txt
