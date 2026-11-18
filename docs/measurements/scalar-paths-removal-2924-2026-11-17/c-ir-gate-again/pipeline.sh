#!/bin/bash
# #2924 C9c's gate in Tier 1's pipeline: promotion's region ticks per function in --tier1 -c of sqlite3.c, Lua 5.4.8 and
# musl's units (one lane), with c9c-knob2.patch (experiment only): AUTO (the vector path up to 16,384 cells), the twin
# (BUSTER_SSA_PROMOTE_SCALAR=1) and the vector path at every size (BUSTER_SSA_FORCE_VECTOR=1); the default passes and
# --tier1-passes=+all; five rounds in turn, under the lock on CPU 2; round 1's objects compared across the three.
set -uo pipefail
D=~/buster-fast-bench/2924-c-df-claude/c9cgate
cd "$D" || exit 1
S=$D/logs/pipeline-status.txt
rm -f "$S"
mkdir -p logs ticks
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: SSA promotion's gate in the pipeline" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
cp ../c9gate/objects.sh objects.sh || { echo "objects.sh missing" >> "$S"; exit 1; }
git -C src checkout -q --detach refs/heads/c9b && git -C src reset -q --hard && git -C src clean -qfd -e build
(cd src && git apply "$D/c9c-knob2.patch") || { echo "knob failed" >> "$S"; exit 1; }
(cd src && $L timeout -k 5 1800 ./build.sh --config Release > "$D/logs/build2.log" 2>&1) || { echo "build failed" >> "$S"; exit 1; }
cp src/build/compiler compiler-pipeline
sha256sum compiler-pipeline > logs/compiler-pipeline.sha256
objects=/dev/shm/claude-2924-c9cgate
run() {
    local config=$1 setting=$2 round=$3 out=$4
    local scalar=0 force=0
    [ $setting = scalar ] && scalar=1
    [ $setting = forced ] && force=1
    if [ $config = all ]; then export EXTRA=--tier1-passes=+all; else export EXTRA=; fi
    rm -f "ticks/$config-$setting-$round.txt"
    BUSTER_SSA_PROMOTE_SCALAR=$scalar BUSTER_SSA_FORCE_VECTOR=$force BUSTER_SSA_PROMOTE_TICKS="$D/ticks/$config-$setting-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-pipeline" "$out" > logs/pipeline-$config-$setting-$round.log 2>&1
    echo "$config $setting $round: $(tr '\n' ' ' < logs/pipeline-$config-$setting-$round.log) $(wc -l < ticks/$config-$setting-$round.txt) lines" >> "$S"
}
for round in 1 2 3 4 5; do
    for config in default all; do
        for setting in auto scalar forced; do
            if [ $round = 1 ]; then
                rm -rf "$objects/$setting"
                run $config $setting $round "$objects/$setting"
            else
                run $config $setting $round "$objects/t"
                rm -rf "$objects/t"
            fi
        done
        if [ $round = 1 ]; then
            (cd "$objects/auto" && find . -name '*.o' | sort) > logs/objects-list-$config.txt
            for setting in scalar forced; do
                n=0; d=0
                while read -r f; do n=$((n+1)); cmp -s "$objects/auto/$f" "$objects/$setting/$f" || { d=$((d+1)); echo "$config $setting differs: $f" >> logs/objects-compare.txt; }; done < logs/objects-list-$config.txt
                echo "objects $config $setting: $n compared, $d differ" >> "$S"
            done
            rm -rf "$objects"
        fi
    done
done
echo done >> "$S"
