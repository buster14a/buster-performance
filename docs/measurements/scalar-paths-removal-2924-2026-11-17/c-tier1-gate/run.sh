#!/bin/bash
# #2924 C7's gate: Tier 1's twins by area, on main caa8f6a3e plus experiment.patch (experiment only: the areas'
# bitmask, BUSTER_TIER1_SCALAR_AREAS, and per-function TSC ticks by region, BUSTER_TIER1_AREA_TICKS), Release, under
# the lock on CPU 2. First the objects of --tier1 -c of sqlite3.c, Lua and musl with each area's bit set alone and all
# ten, against no bit set; then the ticks of every area on vector (0) and on scalar (0x3ff) and of the CFG allocation's
# bit alone (0x40), three rounds in turn.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs ticks
if [ ! -d src ]; then git clone -q ../c6gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster main && git -C src checkout -q --detach caa8f6a3e && git -C src reset -q --hard && git -C src apply "$D/experiment.patch" || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compiler-gate
sha256sum compiler-gate > logs/compiler.sha256
objects=/dev/shm/claude-2924-c7gate
rm -rf "$objects"
for mask in 0 0x1 0x2 0x4 0x8 0x10 0x20 0x40 0x80 0x100 0x200 0x3ff; do
    BUSTER_TIER1_SCALAR_AREAS=$mask $L timeout -k 5 1500 "$D/objects.sh" "$D/compiler-gate" "$objects/$mask" > logs/objects-$mask.log 2>&1
    echo "objects $mask: $(tr '\n' ' ' < logs/objects-$mask.log)" >> logs/status.txt
done
(cd "$objects/0" && find . -name '*.o' | sort) > logs/objects-list.txt
for mask in 0x1 0x2 0x4 0x8 0x10 0x20 0x40 0x80 0x100 0x200 0x3ff; do
    n=0; d=0
    while read -r f; do n=$((n+1)); cmp -s "$objects/0/$f" "$objects/$mask/$f" || { d=$((d+1)); echo "$mask differs: $f" >> logs/objects-compare.txt; }; done < logs/objects-list.txt
    echo "objects $mask: $n compared, $d differ" >> logs/status.txt
done
rm -rf "$objects"
for round in 1 2 3; do
    for mask in 0 0x3ff 0x40; do
        rm -f "ticks/$mask-$round.txt"
        BUSTER_TIER1_SCALAR_AREAS=$mask BUSTER_TIER1_AREA_TICKS="$D/ticks/$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-gate" "$objects/t" > logs/ticks-$mask-$round.log 2>&1
        echo "ticks $mask $round: $(tr '\n' ' ' < logs/ticks-$mask-$round.log) $(wc -l < ticks/$mask-$round.txt) lines" >> logs/status.txt
        rm -rf "$objects"
    done
done
date -u +%FT%TZ > logs/.done
