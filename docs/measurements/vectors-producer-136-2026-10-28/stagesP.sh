#!/bin/bash
# Where #136's producer's -c costs go: -c --time-stages of the frozen sqlite3.c by abP2's base (main 241fcb3's build,
# ../ab619e/base) and head (c0b216d), 21 rounds in turn, each run under its own hold of the lock, pinned to CPU 2,
# with a receipt of each hold (time and CPU 2's policy).
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #136's producer's stages" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/717
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abP2
export SOURCE_DATE_EPOCH=1792454400
export RECEIPTS=$here/stages-receipts.log
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
receipt()
{
    local cpu=/sys/devices/system/cpu/cpu2/cpufreq
    echo "$1 $(date -Ins) governor=$(cat $cpu/scaling_governor) epp=$(cat $cpu/energy_performance_preference) min=$(cat $cpu/scaling_min_freq) max=$(cat $cpu/scaling_max_freq) boost=$(cat /sys/devices/system/cpu/cpufreq/boost) driver=$(cat $cpu/scaling_driver): ${*:2}" >> "$RECEIPTS"
}
export -f receipt
cd $here
for round in $(seq 1 21); do
    for i in 0 1; do
        tree=$([ $(((i + round) % 2)) -eq 0 ] && echo base || echo head)
        echo "== round $round tree $tree" >> stages.log
        $lock bash -c 'receipt acquired "$@"; "$@"; status=$?; receipt "released status=$status" "$@"; exit $status' locked taskset -c 2 $tree/build/compiler -c --time-stages -o /dev/null "${lower[@]}" >> stages.log 2>&1
    done
done
echo "stages done"
