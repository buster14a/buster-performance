#!/bin/bash
declare -- C="/tmp/3346-claude/tree/build/compiler"
declare -- I="/home/david/buster-fast-bench/139-claude/inputs"
declare -- units="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
declare -- sqlite="/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite"
declare -a driver=([0]="--predefines" [1]="/var/lib/buster-9700x/corpora/preprocessor-391e729af658/provenance/gnu17-pinned-predefines.txt" [2]="--no-default-config" [3]="--target=x86_64-linux-gnu" [4]="-march=znver5" [5]="-std=gnu17" [6]="-nostdinc" [7]="-isystem" [8]="/var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/lib/clang/23/include" [9]="-isystem" [10]="/var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/local/include" [11]="-isystem" [12]="/var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/include")
declare -- W="/tmp/3346-claude"
cd $W
for v in off on; do
    opt=(); [ $v = on ] && opt=(--tier1-passes=+storemotion)
    "$C" --tier1 "${opt[@]}" --tier1-report --lanes 1 -c -o scratch/sqlite3-$v.o "${driver[@]}" "$sqlite/sqlite3.c" 2>&1 | grep store-motion | sed "s/^/report sqlite3 $v /" >> logs/reports.txt
    for s in $units; do "$C" --tier1 "${opt[@]}" --tier1-report -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o scratch/lua-$v-$s.o "$I/lua-5.4.8/src/$s.c" 2>&1 | grep store-motion | sed "s/^/report lua $s $v /" >> logs/reports.txt; done
done
for o in scratch/lua-on-*.o; do cmp -s $o ${o/-on-/-off-} || echo "differs $o" >> logs/reports.txt; done
cmp -s scratch/sqlite3-on.o scratch/sqlite3-off.o || echo "differs sqlite3" >> logs/reports.txt
