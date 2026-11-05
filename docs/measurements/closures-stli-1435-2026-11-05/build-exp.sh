#!/usr/bin/env bash
# 1435 experiment builds: #1433's merge (76ad7ebe) with BUSTER_EXPERIMENT_FRAME_PAD (pad.patch: bytes left free below
# the objects of every Tier 1 frame whose function calls); Lua 5.4.8 by --tier1 at pads 0, 8, 16 and 32, each linked
# after a padding object of N bytes (shifts 0 to 112). Each step one hold of the lock.
set -u
W=$HOME/buster-fast-bench/1435-claude
export EXCLUSIVE_OWNER=claude-1435 EXCLUSIVE_TITLE='Problem 1435' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1435
L=$HOME/buster-fast-bench/exclusive.sh
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
log() { echo "$(date -u +%FT%TZ) $*" >> $W/build-exp.log; }
cd $W || exit 1
if [ ! -d exp ]; then git clone -q https://github.com/buster14a/buster exp; fi
(cd exp && git checkout -q 76ad7ebe && git -c user.name=exp -c user.email=exp@example.invalid am -q $W/pad.patch && git log --oneline -2) >> $W/build-exp.log 2>&1
$L bash -c "cd $W/exp && BUSTER_HOST_ARCH=znver5 ./build.sh > $W/build-exp-compiler.log 2>&1"; log "build exit $?"
C=$W/exp/build/compiler
files="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
mkdir -p $W/pad && cd $W/pad || exit 1
for pad in 0 8 16 32; do
    mkdir -p obj-pad$pad
    $L bash -c "cd $W/pad/obj-pad$pad && for f in $files; do BUSTER_EXPERIMENT_FRAME_PAD=$pad $C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o \$f.o $LUA/\$f.c || exit 1; done"; log "objects pad$pad exit $?"
done
# pad 0 against the coordinator's head objects (f9779980's)
same=0; differ=""
for f in $files; do if cmp -s obj-pad0/$f.o $W/base/obj-head/$f.o; then same=$((same+1)); else differ="$differ $f"; fi; done
log "pad0 vs base head objects: $same same, differ:$differ"
for pad in 0 8 16 32; do
    for n in 0 16 32 48 64 80 96 112; do
        objs=""; for f in $files; do objs="$objs obj-pad$pad/$f.o"; done
        $L bash -c "cd $W/pad && cc -o lua-pad$pad-p$n $W/base/pad$n.o $objs -lm -ldl"; log "link pad$pad p$n exit $?"
    done
done
$L bash -c "cd $W/pad && for pad in 0 8 16 32; do ./lua-pad\$pad-p0 $W/base/closures.lua; done" > $W/pad/outputs.txt 2>&1
log "outputs: $(sort $W/pad/outputs.txt | uniq -c | tr '\n' ' ')"
log done
