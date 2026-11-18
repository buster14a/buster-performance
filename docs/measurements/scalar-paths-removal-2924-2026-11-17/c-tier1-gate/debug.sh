#!/bin/bash
# #2924 C7's gate, the debug metadata (bit 10), which runs only under -g: main caa8f6a3e plus experiment-debug.patch
# (experiment.patch with bit 10 and its timer around check_tier1_debug), Release. Under the lock on CPU 2: the objects
# of --tier1 -g -c of sqlite3.c, Lua and musl with every area on vector (0), the debug metadata on scalar (0x400) and
# the schedule on scalar (0x200, which -g runs too), compared against 0; then the ticks of 0, 0x400 and 0x200, three
# rounds in turn.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's gate, the debug metadata" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/debug ticks/debug
git -C src checkout -q --detach caa8f6a3e && git -C src reset -q --hard && git -C src apply "$D/experiment-debug.patch" || { echo "patch failed" >> logs/debug/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/debug/build.log" 2>&1) || { echo "build failed" >> logs/debug/status.txt; exit 1; }
cp src/build/compiler compiler-debug
sha256sum compiler-debug > logs/debug/compiler.sha256
objects=/dev/shm/claude-2924-c7debug
rm -rf "$objects"
for mask in 0 0x400 0x200; do
    EXTRA=-g BUSTER_TIER1_SCALAR_AREAS=$mask $L timeout -k 5 1500 "$D/objects.sh" "$D/compiler-debug" "$objects/$mask" > logs/debug/objects-$mask.log 2>&1
    echo "objects $mask: $(tr '\n' ' ' < logs/debug/objects-$mask.log)" >> logs/debug/status.txt
done
for mask in 0x400 0x200; do
    n=0; d=0
    while read -r f; do n=$((n+1)); cmp -s "$objects/0/$f" "$objects/$mask/$f" || { d=$((d+1)); echo "$mask differs: $f" >> logs/debug/objects-compare.txt; }; done < <(cd "$objects/0" && find . -name '*.o' | sort)
    echo "objects $mask: $n compared, $d differ" >> logs/debug/status.txt
done
rm -rf "$objects"
for round in 1 2 3; do
    for mask in 0 0x400 0x200; do
        rm -f "ticks/debug/$mask-$round.txt"
        EXTRA=-g BUSTER_TIER1_SCALAR_AREAS=$mask BUSTER_TIER1_AREA_TICKS="$D/ticks/debug/$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-debug" "$objects/t" > logs/debug/ticks-$mask-$round.log 2>&1
        echo "ticks $mask $round: $(tr '\n' ' ' < logs/debug/ticks-$mask-$round.log) $(wc -l < ticks/debug/$mask-$round.txt) lines" >> logs/debug/status.txt
        rm -rf "$objects"
    done
done
date -u +%FT%TZ > logs/debug/.done
