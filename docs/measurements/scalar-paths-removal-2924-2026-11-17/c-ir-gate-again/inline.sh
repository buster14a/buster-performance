#!/bin/bash
# #2924 C9e's gate: the inliner's own twins (IrInlineOptions.scalar and the addressed callees' scan, bit 12 of
# c9-inline-knob.patch, the C9 gate's area knob plus that bit) against no bit and against the whole inliner region's bit
# (0x2, which also flips the attributes' scan, the bindings' sort and SROA after an expansion), in Tier 1's pipeline on
# C9b's tree; the default passes and +all, five rounds in turn, under the lock on CPU 2; round 1's objects compared.
set -uo pipefail
D=~/buster-fast-bench/2924-c-df-claude/c9cgate
cd "$D" || exit 1

S=$D/logs/inline-status.txt
rm -f "$S"
mkdir -p logs ticks-inline
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the inliner's own twins" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
git -C src reset -q --hard && git -C src checkout -q --detach refs/heads/c9b && git -C src clean -qfd -e build
(cd src && git apply "$D/c9-inline-knob.patch") || { echo "knob failed" >> "$S"; exit 1; }
(cd src && $L timeout -k 5 1800 ./build.sh --config Release > "$D/logs/build6.log" 2>&1) || { echo "build failed" >> "$S"; exit 1; }
cp src/build/compiler compiler-inline
sha256sum compiler-inline > logs/compiler-inline.sha256
objects=/dev/shm/claude-2924-c9cgate-inline
for round in 1 2 3 4 5; do
    for config in default all; do
        if [ $config = all ]; then export EXTRA=--tier1-passes=+all; else export EXTRA=; fi
        masks="0 0x2 0x1000"
        for mask in $masks; do
            out="$objects/t"
            [ $round = 1 ] && out="$objects/$mask"
            rm -f "ticks-inline/$config-$mask-$round.txt"
            BUSTER_IR_SCALAR_AREAS=$mask BUSTER_IR_AREA_TICKS="$D/ticks-inline/$config-$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-inline" "$out" > logs/inline-$config-$mask-$round.log 2>&1
            echo "$config $mask $round: $(tr '\n' ' ' < logs/inline-$config-$mask-$round.log) $(wc -l < ticks-inline/$config-$mask-$round.txt) lines" >> "$S"
            [ $round = 1 ] || rm -rf "$objects/t"
        done
        if [ $round = 1 ]; then
            (cd "$objects/0" && find . -name '*.o' | sort) > logs/inline-objects-list-$config.txt
            for mask in $masks; do
                [ $mask = 0 ] && continue
                n=0; d=0
                while read -r f; do n=$((n+1)); cmp -s "$objects/0/$f" "$objects/$mask/$f" || { d=$((d+1)); echo "$config $mask differs: $f" >> logs/inline-objects-compare.txt; }; done < logs/inline-objects-list-$config.txt
                echo "objects $config $mask: $n compared, $d differ" >> "$S"
            done
            rm -rf "$objects"
        fi
    done
done
echo done >> "$S"
