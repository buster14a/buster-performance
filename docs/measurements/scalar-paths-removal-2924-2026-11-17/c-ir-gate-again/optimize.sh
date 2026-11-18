#!/bin/bash
# #2924 C9's gate for the verified optimizer's passes in Tier 1's pipeline: its region's ticks per function in --tier1 -c
# of sqlite3.c, Lua 5.4.8 and musl's units (one lane), with c9c-knob3.patch (experiment only): AUTO (the scalar passes
# below 8,192 instructions), the vector passes at every size (BUSTER_IR_OPTIMIZE_FORCE=1) and the scalar ones
# (BUSTER_IR_OPTIMIZE_FORCE=2); the default passes and --tier1-passes=+all; five rounds in turn, under the lock on CPU 2;
# round 1's objects compared across the three. Waits for pipeline.sh to finish first.
set -uo pipefail
D=~/buster-fast-bench/2924-c-df-claude/c9cgate
cd "$D" || exit 1
until grep -q done logs/pipeline-status.txt 2>/dev/null; do sleep 30; done
S=$D/logs/optimize-status.txt
rm -f "$S"
mkdir -p logs ticks-optimize
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the optimizer's gate in the pipeline" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
git -C src checkout -q --detach refs/heads/c9b && git -C src reset -q --hard && git -C src clean -qfd -e build
(cd src && git apply "$D/c9c-knob3.patch") || { echo "knob failed" >> "$S"; exit 1; }
(cd src && $L timeout -k 5 1800 ./build.sh --config Release > "$D/logs/build3.log" 2>&1) || { echo "build failed" >> "$S"; exit 1; }
cp src/build/compiler compiler-optimize
sha256sum compiler-optimize > logs/compiler-optimize.sha256
objects=/dev/shm/claude-2924-c9cgate-optimize
run() {
    local config=$1 setting=$2 round=$3 out=$4
    local force=0
    [ $setting = vector ] && force=1
    [ $setting = scalar ] && force=2
    if [ $config = all ]; then export EXTRA=--tier1-passes=+all; else export EXTRA=; fi
    rm -f "ticks-optimize/$config-$setting-$round.txt"
    BUSTER_IR_OPTIMIZE_FORCE=$force BUSTER_IR_OPTIMIZE_TICKS="$D/ticks-optimize/$config-$setting-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-optimize" "$out" > logs/optimize-$config-$setting-$round.log 2>&1
    echo "$config $setting $round: $(tr '\n' ' ' < logs/optimize-$config-$setting-$round.log) $(wc -l < ticks-optimize/$config-$setting-$round.txt) lines" >> "$S"
}
for round in 1 2 3 4 5; do
    for config in default all; do
        for setting in auto vector scalar; do
            if [ $round = 1 ]; then
                rm -rf "$objects/$setting"
                run $config $setting $round "$objects/$setting"
            else
                run $config $setting $round "$objects/t"
                rm -rf "$objects/t"
            fi
        done
        if [ $round = 1 ]; then
            (cd "$objects/auto" && find . -name '*.o' | sort) > logs/optimize-objects-list-$config.txt
            for setting in vector scalar; do
                n=0; d=0
                while read -r f; do n=$((n+1)); cmp -s "$objects/auto/$f" "$objects/$setting/$f" || { d=$((d+1)); echo "$config $setting differs: $f" >> logs/optimize-objects-compare.txt; }; done < logs/optimize-objects-list-$config.txt
                echo "objects $config $setting: $n compared, $d differ" >> "$S"
            done
            rm -rf "$objects"
        fi
    done
done
echo done >> "$S"
