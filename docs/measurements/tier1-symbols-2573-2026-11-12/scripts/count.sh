#!/usr/bin/env bash
# #2573's dynamic counts, as run in the cloud container: speedtest1 built by a compiler's --tier1 as
# measure-tier1-programs builds it (one unity translation unit, #136's flags), disassembled, run once under callgrind
# with --dump-instr=yes from a fresh database directory, then joined by #1189's gap.c (GAP_INSTRUCTIONS=1) and summed by
# tally.sh. Usage: count.sh COMPILER NAME DIRECTORY, with the inputs below.
set -eu
C=$1; t=$2; G=$3
IN=${IN:?the directory of speedtest1.c}
SQ=${SQ:?the frozen corpus sqlite directory}
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > $IN/speedtest1-unity.c
(unset CPATH C_INCLUDE_PATH; $C --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -I$IN -o $G/st-$t $IN/speedtest1-unity.c -lm)
objdump -d --no-show-raw-insn $G/st-$t > $G/st-$t.dis
mkdir $G/db-$t $G/tmp-$t
(cd $G/db-$t && SQLITE_TMPDIR=$G/tmp-$t valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$G/cg-$t.out $G/st-$t $OPTS speedtest1.db > $G/out-$t.txt 2> $G/vg-$t.txt)
