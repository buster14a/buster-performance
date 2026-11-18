#!/bin/bash
# #2924 C9's gate: the IR's, SSA's and the IR optimizer's twins by area in Tier 1's pipeline, on main 45f3f8561 plus
# knob.patch (experiment only: the areas' bitmask, BUSTER_IR_SCALAR_AREAS, and per-function TSC ticks by area,
# BUSTER_IR_AREA_TICKS), Release, under the lock on CPU 2. Two configurations: --tier1 (default passes) and --tier1
# --tier1-passes=+all (SROA, unrestricted value numbering and LICM, the loop vectorizer, the unroller, memory). First the
# objects of -c of sqlite3.c, Lua and musl with each area's bit set alone and all twelve, against no bit set; then the
# ticks of every area on vector (0) and on its twin (0xfff), three rounds in turn.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the IR's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs ticks
if [ ! -d src ]; then git clone -q ../c7gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster main && git -C src checkout -q --detach 45f3f8561 && git -C src reset -q --hard && git -C src apply "$D/knob.patch" || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compiler-gate
sha256sum compiler-gate > logs/compiler.sha256
objects=/dev/shm/claude-2924-c9gate
masks="0x1 0x2 0x4 0x8 0x10 0x20 0x40 0x80 0x100 0x200 0x400 0x800 0xfff"
for config in default all; do
    if [ $config = all ]; then export EXTRA=--tier1-passes=+all; else export EXTRA=; fi
    rm -rf "$objects"
    for mask in 0 $masks; do
        ERR="$D/logs/stderr-$config-$mask.txt" BUSTER_IR_SCALAR_AREAS=$mask $L timeout -k 5 1500 "$D/objects.sh" "$D/compiler-gate" "$objects/$mask" > logs/objects-$config-$mask.log 2>&1
        echo "objects $config $mask: $(tr '\n' ' ' < logs/objects-$config-$mask.log)" >> logs/status.txt
    done
    (cd "$objects/0" && find . -name '*.o' | sort) > logs/objects-list-$config.txt
    for mask in $masks; do
        n=0; d=0
        while read -r f; do n=$((n+1)); cmp -s "$objects/0/$f" "$objects/$mask/$f" || { d=$((d+1)); echo "$config $mask differs: $f" >> logs/objects-compare.txt; }; done < logs/objects-list-$config.txt
        echo "objects $config $mask: $n compared, $d differ" >> logs/status.txt
    done
    rm -rf "$objects"
done
for round in 1 2 3; do
    for config in default all; do
        if [ $config = all ]; then export EXTRA=--tier1-passes=+all; else export EXTRA=; fi
        for mask in 0 0xfff; do
            rm -f "ticks/$config-$mask-$round.txt"
            BUSTER_IR_SCALAR_AREAS=$mask BUSTER_IR_AREA_TICKS="$D/ticks/$config-$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-gate" "$objects/t" > logs/ticks-$config-$mask-$round.log 2>&1
            echo "ticks $config $mask $round: $(tr '\n' ' ' < logs/ticks-$config-$mask-$round.log) $(wc -l < ticks/$config-$mask-$round.txt) lines" >> logs/status.txt
            rm -rf "$objects"
        done
    done
done
date -u +%FT%TZ > logs/.done
