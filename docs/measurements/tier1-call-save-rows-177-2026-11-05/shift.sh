#!/usr/bin/env bash
# callsave shifts: whether closures.lua's difference between main's and head's Tier 1 Lua is code placement. Each build's
# objects (-c by --tier1) linked by cc after a padding object of N bytes (0 to 112), which moves all of Lua's code by N;
# closures.lua timed at each, main and head alternating, 7 rounds, each run one hold, pinned to CPU 2.
set -u
W=$HOME/buster-fast-bench/177-callsave-claude
export EXCLUSIVE_OWNER=claude-177-callsave EXCLUSIVE_TITLE='Problems 141, 177, 789' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1433
L="$HOME/buster-fast-bench/exclusive.sh"
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
M=$W/main/build/compiler
B=$W/head2/build/compiler
O=$W/out4
mkdir -p $O && cd $O || exit 1
log() { echo "$(date -u +%FT%TZ) $*" >> $O/steps.log; }
log start
cp $W/out/lua/closures.lua $O/
files="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
for c in main head; do
    exe=$([ $c = main ] && echo $M || echo $B)
    mkdir -p $O/obj-$c
    $L bash -c "cd $O/obj-$c && for f in $files; do $exe --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o \$f.o $LUA/\$f.c || exit 1; done"; log "objects $c exit $?"
done
pads="0 16 32 48 64 80 96 112"
for n in $pads; do
    printf 'void buster_pad(void) { __asm__ volatile(".skip %s, 0x90"); }\n' $n > pad$n.c
    clang -c -O2 pad$n.c -o pad$n.o
    for c in main head; do
        objs=""
        for f in $files; do objs="$objs $O/obj-$c/$f.o"; done
        $L bash -c "cd $O && cc -o lua-$c-p$n pad$n.o $objs -lm -ldl"; log "link $c p$n exit $?"
    done
done
# The outputs agree with the first run's clang -O0 reference.
$L bash -c "cd $O && for n in $pads; do for c in main head; do ./lua-\$c-p\$n closures.lua > out-\$c-p\$n.txt 2>&1; cmp -s out-\$c-p\$n.txt $W/out/lua/closures-clang0.out && echo \"\$c p\$n same\" || echo \"\$c p\$n differs\"; done; done" > $O/compare.txt 2>&1
log "compare $(grep -c same $O/compare.txt) same, $(grep -c differs $O/compare.txt) differ"
: > $O/runs.txt
for round in $(seq 1 7); do
    for n in $pads; do
        order="main head"; [ $(((round + n / 16) % 2)) = 0 ] && order="head main"
        for c in $order; do
            $L bash -c "cd $O && taskset -c 2 perf stat -x, -e task-clock,instructions:u,cycles:u -o one.txt ./lua-$c-p$n closures.lua > /dev/null 2>&1"
            awk -F, -v c=$c -v r=$round -v p=$n '/task-clock/{t=$1} /instructions/{i=$1} /cycles/{y=$1} END{print p, r, c, t, i, y}' $O/one.txt >> $O/runs.txt
        done
    done
    log "round $round"
done
log done
