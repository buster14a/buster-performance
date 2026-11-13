#!/usr/bin/env bash
# lua-fixed.sh COMPILER NAME: lua-count.sh's Lua with lstate.c rebuilt by COMPILER's --tier1 with a fixed string-hash
# seed (luai_makeseed, otherwise time() and addresses), so that each script's instruction count repeats; then each
# script under callgrind, checked against clang -O0's output, and gap.c's rows.
set -eu
R=/root/.cache/claude-2602; G=$R/gap; C=$1; t=$2
FILES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
unset CPATH C_INCLUDE_PATH
mkdir -p $R/rep/lua-$t-fixed
$C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX '-Dluai_makeseed(L)=0x2602u' -c -o $R/rep/lua-$t-fixed/lstate.o $R/inputs/lua-5.4.8/src/lstate.c
objs=""; for f in $FILES; do o=$R/rep/lua-$t/$f.o; [ $f = lstate ] && o=$R/rep/lua-$t-fixed/lstate.o; objs="$objs $o"; done
cc -o $G/luaf-$t $objs -lm -ldl
objdump -d --no-show-raw-insn $G/luaf-$t > $G/luaf-$t.dis
for s in calls tables strings arithmetic closures; do
    (cd $R/inputs && valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$G/lfcg-$t-$s.out $G/luaf-$t $s.lua > $G/luaf-$t-$s.out 2> $G/lfvg-$t-$s.txt)
    cmp -s $G/luaf-$t-$s.out $G/lua-ref-$s.out && m=matches || m=DIFFERS
    GAP_INSTRUCTIONS=1 $G/gap count $G/luaf-$t.dis $G/lfcg-$t-$s.out $G/luaf-$t 0 > $G/luaf-$t-$s.tsv
    echo "$s output $m; $(grep 'I   refs' $G/lfvg-$t-$s.txt | sed 's/.*refs: *//') whole process; $(head -1 $G/luaf-$t-$s.tsv | cut -f2) Lua's own"
done
