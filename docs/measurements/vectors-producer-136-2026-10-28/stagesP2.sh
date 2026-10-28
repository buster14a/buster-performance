#!/bin/bash
# Where #136's producer's -c costs go: -c --time-stages of the frozen sqlite3.c by abP2's base (main 241fcb3's build,
# ../ab619e/base) and head (c0b216d): six holds of the 9700X's lock, the trees in turn, each of 7 runs pinned to CPU 2
# (21 per tree), with a receipt of each hold (time and CPU 2's policy).
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #136's producer's stages" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/717
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abP2
export SOURCE_DATE_EPOCH=1792454400
export RECEIPTS=$here/stages2-receipts.log
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
for hold in 1 2 3 4 5 6; do
    tree=$([ $((hold % 2)) -eq 1 ] && echo base || echo head)
    command="for i in 1 2 3 4 5 6 7; do echo \"== hold $hold tree $tree run \$i\"; taskset -c 2 $tree/build/compiler -c --time-stages -o /dev/null ${lower[*]}; done"
    $lock bash -c 'receipt acquired "$@"; "$@"; status=$?; receipt "released status=$status" "$@"; exit $status' locked bash -c "$command" >> stages2.log 2>&1
done
echo "stages done"
