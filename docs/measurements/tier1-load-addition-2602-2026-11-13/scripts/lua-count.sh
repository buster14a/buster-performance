#!/usr/bin/env bash
# lua-count.sh NAME: Lua 5.4.8 linked by cc from records.sh's --tier1 objects (rep/lua-NAME/, the usual order), each of
# the five scripts run under callgrind (its output checked against clang -O0's), then gap.c's rows of every run.
set -eu
R=/root/.cache/claude-2602; G=$R/gap; t=$1
FILES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
objs=""; for f in $FILES; do objs="$objs $R/rep/lua-$t/$f.o"; done
cc -o $G/lua-$t $objs -lm -ldl
[ -x $G/lua-clang0 ] || clang -O0 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o $G/lua-clang0 $(for f in $FILES; do printf '%s ' $R/inputs/lua-5.4.8/src/$f.c; done) -lm -ldl
objdump -d --no-show-raw-insn $G/lua-$t > $G/lua-$t.dis
for s in calls tables strings arithmetic closures; do
    (cd $R/inputs && $G/lua-clang0 $s.lua > $G/lua-ref-$s.out 2>&1)
    (cd $R/inputs && valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$G/lcg-$t-$s.out $G/lua-$t $s.lua > $G/lua-$t-$s.out 2> $G/lvg-$t-$s.txt)
    cmp -s $G/lua-$t-$s.out $G/lua-ref-$s.out && echo "$s output matches clang -O0" || echo "$s output DIFFERS"
    GAP_INSTRUCTIONS=1 $G/gap count $G/lua-$t.dis $G/lcg-$t-$s.out '???' 0x400000 > $G/lua-$t-$s.tsv 2>/dev/null || true
    echo "$s $(grep 'I   refs' $G/lvg-$t-$s.txt)"
done
