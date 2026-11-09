#!/usr/bin/env bash
# 1216 runtime, step 2: objects, executables and their checks. Each revision's compiler (compilers.sh) builds Lua
# 5.4.8's 33 objects and speedtest1 as one unit (speedtest1-unity.c: sqlite3.c then speedtest1.c) once, by --tier1
# -fno-asynchronous-unwind-tables --tier1-report, as the tagged T/U/e builds were. Lua's objects are linked by cc in
# ORDERS orders, the same orders for both revisions: order 0 the usual one, the others shuf's seeded by the order's
# number, as #1435's orders.sh. speedtest1's single object can only move as a whole (the driver refuses
# -ffunction-sections), so its placements are shifts: linked by cc after a padding object of each SHIFTS' bytes. Every
# executable is checked before it is timed: each script's output against clang -O0's, speedtest1's --verify hash. Each
# compile, link and check is one hold of the lock.
set -u
W=$HOME/buster-fast-bench/1216-droid
export EXCLUSIVE_OWNER=droid-1216 EXCLUSIVE_TITLE='Tier 1 dispatch loops keep loop-carried values in registers (#1216)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1216
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
ORDERS=${ORDERS:-33}
SHIFTS=${SHIFTS:-0 528 1056 1584 2112 2640 3168 3696}
files="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
scripts="calls tables strings arithmetic closures"
SQLFLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
STOPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
HASH="1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739"
LUAHOT="luaV_execute luaD_precall luaD_poscall luaH_getshortstr luaH_get luaH_newkey luaV_finishget luaC_step"
STHOT="sqlite3VdbeExec sqlite3BtreeIndexMoveto sqlite3BtreeTableMoveto sqlite3VdbeRecordCompareWithSkip sqlite3VdbeSerialGet"
log() { echo "$(date -u +%FT%TZ) $*" >> $W/prepare.log; }
unset CPATH C_INCLUDE_PATH
cd $W || exit 1
mkdir -p exe pad check
status=0
for t in base head; do
    C=$W/$t/build/compiler
    mkdir -p obj-$t
    $L bash -c "cd $W/obj-$t && for f in $files; do $C --tier1 -fno-asynchronous-unwind-tables --tier1-report -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o \$f.o $I/lua/lua-5.4.8/src/\$f.c > \$f.report 2>&1 || exit 1; done"
    rc=$?; log "$t lua objects exit $rc"; [ $rc = 0 ] || status=1
    $L bash -c "cd $W/obj-$t && $C --tier1 -fno-asynchronous-unwind-tables --tier1-report $SQLFLAGS -I$I/sqlite -c -o speedtest1.o $I/st/speedtest1-unity.c > speedtest1.report 2>&1"
    rc=$?; log "$t speedtest1 object exit $rc"; [ $rc = 0 ] || status=1
    (cd obj-$t && sha256sum *.o) > objects-$t.sha256
    for f in speedtest1 $files; do echo "$f $(grep -P '^tier1\tfunctions' obj-$t/$f.report | tr '\t' '\n' | grep -E '^(compiled|fallbacks|spill_stores|spill_loads|edge_moves)=' | paste -sd' ')"; done > reports-$t.txt
done
[ $status = 0 ] || { log "objects failed"; exit 1; }
log "speedtest1.o .text: $(readelf -SW obj-head/speedtest1.o | grep -E ' \.text( |$)' | head -1)"
: > orders.txt
for o in $(seq 0 $((ORDERS - 1))); do
    if [ $o = 0 ]; then perm="$files"; else perm=$(echo $files | tr ' ' '\n' | shuf --random-source=<(yes $o) | tr '\n' ' '); fi
    echo "$o $perm" >> orders.txt
    for t in base head; do
        objs=""; for f in $perm; do objs="$objs $W/obj-$t/$f.o"; done
        $L bash -c "cc -o $W/exe/lua-$t-o$o $objs -lm -ldl"
        rc=$?; [ $rc = 0 ] || { log "link lua-$t-o$o exit $rc"; status=1; }
    done
done
for n in $SHIFTS; do
    printf '\t.text\n\t.skip %d, 0xcc\n' $n | clang -c -x assembler -o pad/pad$n.o -
    for t in base head; do
        $L bash -c "cc -o $W/exe/st-$t-s$n $W/pad/pad$n.o $W/obj-$t/speedtest1.o -lm"
        rc=$?; [ $rc = 0 ] || { log "link st-$t-s$n exit $rc"; status=1; }
    done
done
log "links done, status $status"
: > checks.txt
for e in exe/lua-*; do
    $L bash -c "cd $I/lua && bad=''; for s in $scripts; do $W/$e \$s.lua > $W/check/out.txt 2>&1; rc=\$?; { [ \$rc = 0 ] && cmp -s $W/check/out.txt $I/ref/\$s-clang0.out; } || bad=\"\$bad \$s:\$rc\"; done; echo \"$e \${bad:-ok}\"" >> checks.txt
done
for e in exe/st-*; do
    $L bash -c "d=\$(mktemp -d /dev/shm/st1216.XXXXXX) && mkdir \$d/db \$d/tmp && cd \$d/db && SQLITE_TMPDIR=\$d/tmp $W/$e $STOPTS --verify speedtest1.db > $W/check/st.txt 2>&1; rc=\$?; rm -rf \$d; exit \$rc"
    rc=$?
    if [ $rc = 0 ] && grep -qx "Verification Hash: $HASH" check/st.txt; then echo "$e ok" >> checks.txt; else echo "$e failed:$rc $(grep 'Verification Hash' check/st.txt)" >> checks.txt; fi
done
log "checks: $(awk '{print $2}' checks.txt | sort | uniq -c | tr '\n' ' ')"
grep -vq ' ok$' checks.txt && status=1
(cd exe && sha256sum *) > executables.sha256
for e in exe/*; do
    case $e in exe/lua-*) hot=$LUAHOT ;; *) hot=$STHOT ;; esac
    echo "$e $(stat -c %s $e) $(nm $e | awk -v h=" $hot " 'index(h, " " $3 " ") { printf "%s=%s ", $3, $1 }')"
done > addresses.txt
log "prepare done, status $status"
exit $status
