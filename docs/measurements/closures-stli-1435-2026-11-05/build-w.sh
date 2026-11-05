#!/usr/bin/env bash
# 1435 experiment builds, part 2: the pad experiment's compiler with BUSTER_EXPERIMENT_RSP_DISP8 (disp8.patch: an rsp
# base's zero displacement encoded as an 8-bit zero, so that code is as long as with the objects 8 bytes up); Lua by
# --tier1 with pad 0 and the 8-bit zeros (pad0w), linked at shifts 0 to 112. Each step one hold of the lock.
set -u
W=$HOME/buster-fast-bench/1435-claude
export EXCLUSIVE_OWNER=claude-1435 EXCLUSIVE_TITLE='Problem 1435' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1435
L=$HOME/buster-fast-bench/exclusive.sh
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
log() { echo "$(date -u +%FT%TZ) $*" >> $W/build-w.log; }
cd $W/exp || exit 1
git -c user.name=exp -c user.email=exp@example.invalid am -q $W/disp8.patch >> $W/build-w.log 2>&1; git log --oneline -3 >> $W/build-w.log
$L bash -c "cd $W/exp && BUSTER_HOST_ARCH=znver5 ./build.sh > $W/build-w-compiler.log 2>&1"; log "build exit $?"
C=$W/exp/build/compiler
files="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
cd $W/pad || exit 1
mkdir -p obj-pad0w obj-check0 obj-check8
$L bash -c "cd $W/pad/obj-pad0w && for f in $files; do BUSTER_EXPERIMENT_RSP_DISP8=1 $C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o \$f.o $LUA/\$f.c || exit 1; done"; log "objects pad0w exit $?"
$L bash -c "cd $W/pad/obj-check0 && for f in $files; do $C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o \$f.o $LUA/\$f.c || exit 1; done"; log "objects check0 exit $?"
$L bash -c "cd $W/pad/obj-check8 && for f in $files; do BUSTER_EXPERIMENT_FRAME_PAD=8 $C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o \$f.o $LUA/\$f.c || exit 1; done"; log "objects check8 exit $?"
s0=0; s8=0
for f in $files; do cmp -s obj-check0/$f.o obj-pad0/$f.o && s0=$((s0+1)); cmp -s obj-check8/$f.o obj-pad8/$f.o && s8=$((s8+1)); done
log "rebuilt compiler: pad0 objects $s0/33 same, pad8 objects $s8/33 same"
for n in 0 16 32 48 64 80 96 112; do
    objs=""; for f in $files; do objs="$objs obj-pad0w/$f.o"; done
    $L bash -c "cd $W/pad && cc -o lua-pad0w-p$n $W/base/pad$n.o $objs -lm -ldl"; log "link pad0w p$n exit $?"
done
$L bash -c "cd $W/pad && ./lua-pad0w-p0 $W/base/closures.lua" > $W/pad/outputs-w.txt 2>&1
log "output: $(grep closures $W/pad/outputs-w.txt)"
for b in pad0 pad8 pad0w; do
    echo "$b $(stat -c %s lua-$b-p0) $(nm lua-$b-p0 | grep -E ' (setnodevector|luaV_execute|luaD_precall|luaH_getshortstr|moveresults|luaD_poscall)$' | sort | awk '{printf "%s=%s ", $3, $1}')" >> $W/build-w.log
done
log done
