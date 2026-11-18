#!/bin/bash
# #2924 C9's gate again, on C9b's tree (the verifier and the lowering have one path, so an area's region holds its own
# twin alone): c9-areas-knob.patch (experiment only; the C9 gate's knob.patch adapted: BUSTER_IR_SCALAR_AREAS and
# BUSTER_IR_AREA_TICKS), each remaining area's bit alone against no bit, in Tier 1's pipeline (--tier1 -c of sqlite3.c,
# Lua 5.4.8 and musl's units, one lane), the default passes and --tier1-passes=+all, five rounds in turn, under the lock
# on CPU 2; round 1's objects compared against no bit.
set -uo pipefail
D=~/buster-fast-bench/2924-c-df-claude/c9cgate
cd "$D" || exit 1
until grep -q done logs/optimize-status.txt 2>/dev/null; do sleep 30; done
S=$D/logs/areas-status.txt
rm -f "$S"
mkdir -p logs ticks-areas
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the IR's gate again, each area alone" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
git -C src checkout -q --detach refs/heads/c9b && git -C src reset -q --hard && git -C src clean -qfd -e build
(cd src && git apply "$D/c9-areas-knob.patch") || { echo "knob failed" >> "$S"; exit 1; }
(cd src && $L timeout -k 5 1800 ./build.sh --config Release > "$D/logs/build4.log" 2>&1) || { echo "build failed" >> "$S"; exit 1; }
cp src/build/compiler compiler-areas
sha256sum compiler-areas > logs/compiler-areas.sha256
objects=/dev/shm/claude-2924-c9cgate-areas
for round in 1 2 3 4 5; do
    for config in default all; do
        if [ $config = all ]; then export EXTRA=--tier1-passes=+all; masks="0 0x2 0x4 0x8 0x20 0x40 0x80 0x100 0x200 0x400"; else export EXTRA=; masks="0 0x2 0x8 0x20 0x40 0x80 0x400"; fi
        for mask in $masks; do
            out="$objects/t"
            [ $round = 1 ] && out="$objects/$mask"
            rm -f "ticks-areas/$config-$mask-$round.txt"
            BUSTER_IR_SCALAR_AREAS=$mask BUSTER_IR_AREA_TICKS="$D/ticks-areas/$config-$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-areas" "$out" > logs/areas-$config-$mask-$round.log 2>&1
            echo "$config $mask $round: $(tr '\n' ' ' < logs/areas-$config-$mask-$round.log) $(wc -l < ticks-areas/$config-$mask-$round.txt) lines" >> "$S"
            [ $round = 1 ] || rm -rf "$objects/t"
        done
        if [ $round = 1 ]; then
            (cd "$objects/0" && find . -name '*.o' | sort) > logs/areas-objects-list-$config.txt
            for mask in $masks; do
                [ $mask = 0 ] && continue
                n=0; d=0
                while read -r f; do n=$((n+1)); cmp -s "$objects/0/$f" "$objects/$mask/$f" || { d=$((d+1)); echo "$config $mask differs: $f" >> logs/areas-objects-compare.txt; }; done < logs/areas-objects-list-$config.txt
                echo "objects $config $mask: $n compared, $d differ" >> "$S"
            done
            rm -rf "$objects"
        fi
    done
done
echo done >> "$S"
