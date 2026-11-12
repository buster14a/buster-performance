#!/bin/bash
# measure.sh COMPILER OUT: speedtest1 and Lua by COMPILER --tier1 with tags (BUSTER_TIER1_KINDS), each run under
# callgrind, joined by #1189's gap.c; OUT/summary.txt sums the tags (all functions, and the hot two).
set -u
compiler=$(readlink -f "$1"); out=$(readlink -f "$2")
W=/home/user/w2553; I=$W/inputs
mkdir -p "$out"; cd "$out"
export LC_ALL=C
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > speedtest1-unity.c
BUSTER_TIER1_KINDS=$out/speedtest1.kinds "$compiler" --tier1 -fno-asynchronous-unwind-tables --tier1-report \
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$I -o speedtest1 speedtest1-unity.c -lm > st-build.txt 2>&1 || echo "speedtest1 build failed"
src=()
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do src+=("$I/lua-5.4.8/src/$s.c"); done
BUSTER_TIER1_KINDS=$out/lua.kinds "$compiler" --tier1 -fno-asynchronous-unwind-tables --tier1-report -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua "${src[@]}" -lm -ldl > lua-build.txt 2>&1 || echo "lua build failed"
grep -v '^tier1-kind-outcome' st-build.txt | grep '^tier1' | tr '\t' '\n' | grep -E '^(spill_stores|spill_loads|edge_moves|records)=' | tr '\n' ' ' > reports.txt; echo >> reports.txt
grep -v '^tier1-kind-outcome' lua-build.txt | grep '^tier1' | tr '\t' '\n' | grep -E '^(spill_stores|spill_loads|edge_moves|records)=' | tr '\n' ' ' >> reports.txt; echo >> reports.txt
objdump -d --no-show-raw-insn speedtest1 > speedtest1.dis; objdump -d --no-show-raw-insn lua > lua.dis
opts="--shrink-memory --reprepare --stats --journal wal --size ${SIZE:-5} --heap 40000000 64 --testset mix1"
run()
{
    local p=$1
    if [ "$p" = speedtest1 ]; then
        local d; d=$(mktemp -d /dev/shm/st.XXXXXX); mkdir -p "$d/tmp"
        (cd "$d" && SQLITE_TMPDIR=$d/tmp "$out/speedtest1" $opts --verify v.db 2>&1 | grep 'Verification Hash' > "$out/st.verify")
        rm -rf "$d"/v.db* ; mkdir -p "$d/tmp"
        (cd "$d" && SQLITE_TMPDIR=$d/tmp valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$out/st.cg "$out/speedtest1" $opts s.db > /dev/null 2>&1)
        rm -rf "$d"
    else
        (cd $I/scripts && valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$out/$p.cg "$out/lua" $p.lua > $out/$p.out 2>/dev/null)
    fi
}
export -f run; export out I opts
printf '%s\n' ${PROGRAMS:-speedtest1 calls tables strings arithmetic closures} | xargs -P ${JOBS:-4} -I{} bash -c 'run {}'
G=$W/bin/gap
"$G" count speedtest1.dis st.cg '???' 0x108000 speedtest1.kinds > st.tsv 2> st.gaperr
for s in calls tables strings arithmetic closures; do [ -e $s.cg ] && "$G" count lua.dis $s.cg '???' 0x108000 lua.kinds > $s.tsv 2> $s.gaperr; done
{
  cat reports.txt; cat st.verify
  for f in st calls tables strings arithmetic closures; do [ -e $f.tsv ] || continue
    awk -F'\t' -v f=$f '$1 !~ /^#/ { k[$2]+=$4; if ($1=="luaV_execute"||$1=="sqlite3VdbeExec") h[$2]+=$4; t+=$4 } END { printf "%s total %d", f, t; n=split("e h x T t U u",L," "); for(i=1;i<=n;i++) printf " %s=%d", L[i], k[L[i]]; printf " | hot"; for(i=1;i<=n;i++) printf " %s=%d", L[i], h[L[i]]; printf "\n" }' $f.tsv
  done
} > summary.txt
cat summary.txt
