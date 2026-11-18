#!/bin/bash
# #2979: LICM walks each loop's own blocks for the unrestricted motion too (fix-2979.patch on main 4e821bbab), measured
# in one executable with the C9 gate's knob (knob-2979.patch, experiment only): bit 12 sets IrLicmOptions.whole, the
# whole-function algorithm the walk replaced (its sweeps, or with bit 7 its worklist). Release, under the lock on CPU 2.
# 1. test-ir-licm, test-ir-metamorphic, and test-ir-source --passes on sqlite3.c and Lua (the walk against the
#    whole-function worklist on every function);
# 2. objects of --tier1 --tier1-passes=+all -c of sqlite3.c, Lua and musl with the walk (0), the sweeps (0x1000) and
#    the worklist (0x1080), compared;
# 3. three rounds of ticks of the three.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="LICM walks each loop's own blocks" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2979
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs ticks
if [ ! -d src ]; then git clone -q ../c7gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster main && git -C src checkout -q --detach 4e821bbab && git -C src reset -q --hard && git -C src apply "$D/fix-2979.patch" && git -C src apply "$D/knob-2979.patch" || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compiler-2979
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$D/../c3pr/inputs/lua-5.4.8/src
(cd src && $L timeout -k 5 1500 ../compiler-2979 test-ir-licm > "$D/logs/test-ir-licm.log" 2>&1; echo "test-ir-licm: $?" >> "$D/logs/status.txt")
(cd src && $L timeout -k 5 1500 ../compiler-2979 test-ir-metamorphic > "$D/logs/test-ir-metamorphic.log" 2>&1; echo "test-ir-metamorphic: $?" >> "$D/logs/status.txt")
(cd src && $L timeout -k 5 1500 ../compiler-2979 test-ir-source --passes -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" > "$D/logs/test-ir-source-sqlite.log" 2>&1; echo "test-ir-source --passes sqlite: $?" >> "$D/logs/status.txt")
(cd src && $L timeout -k 5 1500 ../compiler-2979 test-ir-source --passes "$lua"/*.c > "$D/logs/test-ir-source-lua.log" 2>&1; echo "test-ir-source --passes lua: $?" >> "$D/logs/status.txt")
objects=/dev/shm/claude-2979
export EXTRA=--tier1-passes=+all
rm -rf "$objects"
for mask in 0 0x1000 0x1080; do
    BUSTER_IR_SCALAR_AREAS=$mask $L timeout -k 5 1500 "$D/objects.sh" "$D/compiler-2979" "$objects/$mask" > logs/objects-$mask.log 2>&1
    echo "objects $mask: $(tr '\n' ' ' < logs/objects-$mask.log)" >> logs/status.txt
done
(cd "$objects/0" && find . -name '*.o' | sort) > logs/objects-list.txt
for mask in 0x1000 0x1080; do
    n=0; d=0
    while read -r f; do n=$((n+1)); cmp -s "$objects/0/$f" "$objects/$mask/$f" || { d=$((d+1)); echo "$mask differs: $f" >> logs/objects-compare.txt; }; done < logs/objects-list.txt
    echo "objects $mask: $n compared, $d differ" >> logs/status.txt
done
rm -rf "$objects"
for round in 1 2 3; do
    for mask in 0 0x1000 0x1080; do
        rm -f "ticks/all-$mask-$round.txt"
        BUSTER_IR_SCALAR_AREAS=$mask BUSTER_IR_AREA_TICKS="$D/ticks/all-$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-2979" "$objects/t" > logs/ticks-$mask-$round.log 2>&1
        echo "ticks $mask $round: $(tr '\n' ' ' < logs/ticks-$mask-$round.log) $(wc -l < ticks/all-$mask-$round.txt) lines" >> logs/status.txt
        rm -rf "$objects"
    done
done
date -u +%FT%TZ > logs/.done
