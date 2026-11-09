#!/usr/bin/env bash
# m.sh COMPILER OUT: build speedtest1 and Lua by COMPILER's --tier1 with origin tags, check them, run each under
# callgrind (through a generic-x86-64 glibc loader, since the host's znver4 glibc has AVX-512 valgrind can't run),
# and join counts with tags (gap). Prints T/U/e per program and for the two interpreters' functions.
set -u
S=~/.cache/droid-1216/S; G=~/.cache/droid-1216/glibc
C=$(readlink -f $1); O=$2; mkdir -p $O/cg; O=$(readlink -f $O)
Q=$S/corpus/sqlite; SRC=$S/inputs/st; LUA=$S/inputs/lua/lua-5.4.8/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
lua_files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do lua_files="$lua_files $LUA/$f.c"; done
unset CPATH C_INCLUDE_PATH
if [ "${SKIP_RUN:-0}" != 1 ]; then
rm -f $O/st.kinds $O/lua.kinds
BUSTER_TIER1_KINDS=$O/st.kinds $C --tier1 -fno-asynchronous-unwind-tables --tier1-report $FLAGS -I$Q -o $O/st-t1 $SRC/speedtest1-unity.c -lm > $O/build-st.txt 2>&1 || { echo "st build failed"; exit 1; }
BUSTER_TIER1_KINDS=$O/lua.kinds $C --tier1 -fno-asynchronous-unwind-tables --tier1-report -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o $O/lua-t1 $lua_files -lm -ldl > $O/build-lua.txt 2>&1 || { echo "lua build failed"; exit 1; }
for b in st lua; do echo "$b $(grep -P '^tier1\tfunctions' $O/build-$b.txt | tr '\t' '\n' | grep -E '^(compiled|fallbacks|spill_stores|spill_loads|call_stores|call_loads|edge_moves|records)=' | paste -sd' ')"; done
objdump -d --no-show-raw-insn $O/st-t1 > $O/st.dis; objdump -d --no-show-raw-insn $O/lua-t1 > $O/lua.dis
status=0
d=$(mktemp -d /dev/shm/st.XXXXXX); mkdir -p $d/db $d/tmp
(cd $d/db && SQLITE_TMPDIR=$d/tmp $O/st-t1 --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 --verify speedtest1.db > $O/verify.txt 2>&1); rm -rf $d
grep -qx 'Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739' $O/verify.txt && echo "verify ok" || { echo "VERIFY FAILED"; status=1; }
for s in calls tables strings arithmetic closures; do
  (cd $S/inputs/lua && $O/lua-t1 $s.lua > $O/$s.out 2>&1)
  cmp -s $O/$s.out $S/ref/$s-clang0.out || { echo "LUA $s DIFFERS"; status=1; }
done
[ $status = 0 ] || exit 1
vg() { valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$1 $G/ld-linux-x86-64.so.2 --library-path $G "${@:2}"; }
export -f vg; export G O S
{ echo st; for s in calls tables strings arithmetic closures; do echo $s; done; } | xargs -P ${JOBS:-6} -I{} bash -c '
  if [ {} = st ]; then d=$(mktemp -d /dev/shm/st.XXXXXX); mkdir -p $d/db $d/tmp; (cd $d/db && SQLITE_TMPDIR=$d/tmp vg $O/cg/st.cg $O/st-t1 --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 speedtest1.db > $O/cg/st.out 2> $O/cg/st.err); rm -rf $d;
  else (cd $S/inputs/lua && vg $O/cg/{}.cg $O/lua-t1 {}.lua > $O/cg/{}.out 2> $O/cg/{}.err); fi'
fi
# Valgrind names the program by its path and gives its unrelocated addresses: base 0.
for r in st calls tables strings arithmetic closures; do
  if [ $r = st ]; then p=$O/st-t1; dis=$O/st.dis; k=$O/st.kinds; else p=$O/lua-t1; dis=$O/lua.dis; k=$O/lua.kinds; fi
  b=0x0
  $S/tools/gap count $dis $O/cg/$r.cg $p $b $k > $O/cg/$r.tsv 2> $O/cg/$r.gaperr
  echo "$r base=$b $(grep -m1 '^#check' $O/cg/$r.tsv) total=$(grep -m1 '^summary' $O/cg/$r.cg | cut -d' ' -f2)"
done
awk -F'\t' '
  FNR==1 { r=FILENAME; sub(/.*\//,"",r); sub(/\.tsv$/,"",r); prog = (r=="st") ? "speedtest1" : "lua" }
  /^#/ {next}
  ($2=="T"||$2=="U"||$2=="e") { s[prog,$2]+=$4; if ($1=="sqlite3VdbeExec"||$1=="luaV_execute") f[$1,$2]+=$4 }
  ($2=="C"||$2=="R"||$2=="S"||$2=="L"||$2=="r") { o[prog,$2]+=$4 }
  { all[prog]+=$4 }
  END {
    for (p in all) {}
    split("speedtest1 lua", ps, " ");
    for (i=1;i<=2;i++) { p=ps[i]; printf "%s: T=%d U=%d e=%d TUe=%d | S=%d L=%d C=%d R=%d r=%d | program=%d\n", p, s[p,"T"], s[p,"U"], s[p,"e"], s[p,"T"]+s[p,"U"]+s[p,"e"], o[p,"S"], o[p,"L"], o[p,"C"], o[p,"R"], o[p,"r"], all[p] }
    split("sqlite3VdbeExec luaV_execute", fs, " ");
    for (i=1;i<=2;i++) { n=fs[i]; printf "%s: T=%d U=%d e=%d TUe=%d\n", n, f[n,"T"], f[n,"U"], f[n,"e"], f[n,"T"]+f[n,"U"]+f[n,"e"] }
  }' $O/cg/st.tsv $O/cg/calls.tsv $O/cg/tables.tsv $O/cg/strings.tsv $O/cg/arithmetic.tsv $O/cg/closures.tsv | tee $O/summary.txt
