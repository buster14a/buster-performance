#!/usr/bin/env bash
# st.sh COMPILER DIR: speedtest1 by COMPILER --tier1 as the #1217 record builds it (DIR/st-t1), its verification hash,
# and a callgrind run joined by gap.c (DIR/st.tsv); prints the whole process's count. COMPILER=clang2 builds clang -O2's.
set -u
S=${S:-$HOME/.cache/claude-2593/S}
B=$1; d=$2; shift 2
Q=$S/corpus/sqlite; SRC=$S/inputs
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
mkdir -p $d; d=$(readlink -f $d)
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > $d/speedtest1-unity.c
unset CPATH C_INCLUDE_PATH
if [ "$B" = clang2 ]; then
  clang -O2 $FLAGS -I$Q -I$SRC -c -o $d/sqlite3-c2.o $Q/sqlite3.c && clang -O2 $FLAGS -I$Q -I$SRC -c -o $d/speedtest1-c2.o $SRC/speedtest1.c && clang -O2 -o $d/st-t1 $d/speedtest1-c2.o $d/sqlite3-c2.o -lm || exit 1
  o=x; base=0
else
  $B --tier1 -fno-asynchronous-unwind-tables "$@" $FLAGS -I$Q -I$SRC -o $d/st-t1 $d/speedtest1-unity.c -lm || exit 1
  o='???'; base=0x108000
fi
run_st() { local x=$(mktemp -d /dev/shm/st.XXXXXX); mkdir -p $x/db $x/tmp; (cd $x/db && SQLITE_TMPDIR=$x/tmp "${@:2}" $d/st-t1 $OPTS $1 speedtest1.db); local rc=$?; rm -rf $x; return $rc; }
run_st --verify > $d/verify.txt 2>&1; echo "verify $? $(grep 'Verification Hash' $d/verify.txt)" > $d/st-check.txt
run_st "" valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$d/st.cg > $d/st-cg.out 2> $d/st-cg.err
objdump -d --no-show-raw-insn $d/st-t1 > $d/st.dis
[ "$B" = clang2 ] && o=$(sed -n 's/^cmd: *\([^ ]*\).*/\1/p' $d/st.cg)
GAP_INSTRUCTIONS=1 $S/gap count $d/st.dis $d/st.cg "$o" $base > $d/st.tsv
echo "$(cat $d/st-check.txt) instructions $(grep -m1 '^summary' $d/st.cg | cut -d' ' -f2)"
