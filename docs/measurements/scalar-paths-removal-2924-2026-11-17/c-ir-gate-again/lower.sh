#!/bin/bash
# #2924 C9b's lowering again: C9b's tests commit 7af2036db (both lowering paths, one verifier) plus c9b-lower-knob.patch
# (experiment only: BUSTER_IR_LOWER_SCALAR=1 takes the twin; BUSTER_IR_LOWER_TICKS, a line per lowering: Tier 0 entries,
# TSC ticks), --tier1 -c of sqlite3.c, Lua 5.4.8 and musl's units (one lane), default passes and +all, five rounds in turn,
# under the lock on CPU 2; round 1's objects compared.
set -uo pipefail
D=~/buster-fast-bench/2924-c-df-claude/c9cgate
cd "$D" || exit 1
S=$D/logs/lower-status.txt
rm -f "$S"
mkdir -p logs ticks-lower
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the lowering's gate again" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
git -C src fetch -q https://github.com/buster14a/buster claude/wonderful-wozniak-vbfba7 main 2>/dev/null
git -C src cat-file -e 7af2036db^{commit} || { echo "7af2036db missing" >> "$S"; exit 1; }
git -C src reset -q --hard && git -C src checkout -q --detach 7af2036db && git -C src clean -qfd -e build
(cd src && git apply "$D/c9b-lower-knob.patch") || { echo "knob failed" >> "$S"; exit 1; }
(cd src && $L timeout -k 5 1800 ./build.sh --config Release > "$D/logs/build5.log" 2>&1) || { echo "build failed" >> "$S"; exit 1; }
cp src/build/compiler compiler-lower
sha256sum compiler-lower > logs/compiler-lower.sha256
objects=/dev/shm/claude-2924-c9cgate-lower
for round in 1 2 3 4 5; do
    for config in default all; do
        if [ $config = all ]; then export EXTRA=--tier1-passes=+all; else export EXTRA=; fi
        for setting in vector scalar; do
            knob=0; [ $setting = scalar ] && knob=1
            out="$objects/t"; [ $round = 1 ] && out="$objects/$setting"
            rm -f "ticks-lower/$config-$setting-$round.txt"
            BUSTER_IR_LOWER_SCALAR=$knob BUSTER_IR_LOWER_TICKS="$D/ticks-lower/$config-$setting-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-lower" "$out" > logs/lower-$config-$setting-$round.log 2>&1
            echo "$config $setting $round: $(tr '\n' ' ' < logs/lower-$config-$setting-$round.log) $(wc -l < ticks-lower/$config-$setting-$round.txt) lines" >> "$S"
            [ $round = 1 ] || rm -rf "$objects/t"
        done
        if [ $round = 1 ]; then
            n=0; d=0
            while read -r f; do n=$((n+1)); cmp -s "$objects/vector/$f" "$objects/scalar/$f" || d=$((d+1)); done < <(cd "$objects/vector" && find . -name '*.o' | sort)
            echo "objects $config scalar: $n compared, $d differ" >> "$S"
            rm -rf "$objects"
        fi
    done
done
echo done >> "$S"
