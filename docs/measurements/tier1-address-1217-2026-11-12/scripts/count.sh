#!/usr/bin/env bash
# count.sh DIR KIND: DIR's st-KIND and lua-KIND checked (speedtest1's hash, each script against clang -O0's reference
# when present, else against clang -O2's output) and run under callgrind (--dump-instr=yes), then joined by gap.c with
# GAP_INSTRUCTIONS=1 into DIR/KIND-*.tsv.
set -u
S=${S:?the scratch directory: corpus/sqlite, inputs/speedtest1.c and inputs/lua-5.4.8, and gap (tools/gap.c of tier1-gap-1189-2026-11-03, built)}
d=$(readlink -f $1); kind=$2
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
SCRIPTS=${SCRIPTS:-$S/inputs}
cd $d && mkdir -p cg
run_st() { local x=$(mktemp -d /dev/shm/st.XXXXXX); mkdir -p $x/db $x/tmp; (cd $x/db && SQLITE_TMPDIR=$x/tmp "${@:2}" $d/st-$kind $OPTS $1 speedtest1.db); local rc=$?; rm -rf $x; return $rc; }
run_st --verify > verify-$kind.txt 2>&1; echo "verify $? $(grep 'Verification Hash' verify-$kind.txt)" > check-$kind.txt
for s in calls tables strings arithmetic closures; do
  (cd $SCRIPTS && $d/lua-$kind $s.lua > $d/$s-$kind.out 2>&1); echo "$s $?" >> check-$kind.txt
done
run_st "" valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$d/cg/st-$kind.cg > cg/st-$kind.out 2> cg/st-$kind.err &
for s in calls tables strings arithmetic closures; do
  (cd $SCRIPTS && valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$d/cg/$s-$kind.cg $d/lua-$kind $s.lua > $d/cg/$s-$kind.out 2> $d/cg/$s-$kind.err) &
  [ $s = tables ] && wait
done
wait
for f in st calls tables strings arithmetic closures; do echo "$f $(grep -m1 '^summary' cg/$f-$kind.cg | cut -d' ' -f2)"; done > instructions-$kind.txt
objdump -d --no-show-raw-insn st-$kind > st-$kind.dis; objdump -d --no-show-raw-insn lua-$kind > lua-$kind.dis
object() { sed -n 's/^cmd: *\([^ ]*\).*/\1/p' "$1"; }
for f in st calls tables strings arithmetic closures; do
  b=lua; [ $f = st ] && b=st
  ob=$(grep -m1 '^ob=' cg/$f-$kind.cg)
  if [ $kind = t1 ]; then o='???'; base=0x108000; else o=$(object cg/$f-$kind.cg); base=0; fi
  GAP_INSTRUCTIONS=1 $S/gap count $b-$kind.dis cg/$f-$kind.cg "$o" $base > $f-$kind.tsv
done
cat check-$kind.txt instructions-$kind.txt
