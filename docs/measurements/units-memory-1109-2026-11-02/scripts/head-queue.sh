#!/bin/bash
# head-queue.sh: the PR's head 08cf75ce against its main parent a4a2182a. Each tree built, then two interleaved rounds of
# build.sh's 42 sources with -c (main and the head by default, the head with 12 GiB and 6 GiB) and linked into one
# executable (main and the head by default, the head with 12 GiB); each build and run its own hold of the lock.
export LC_ALL=C
dir=~/buster-fast-bench/1109-claude
units=$dir/units2.tsv
link=$dir/link2.tsv
env=$dir/environment-head.txt
lock() { EXCLUSIVE_OWNER=claude-1109 EXCLUSIVE_TITLE="Problem 1109: $1" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1165 ~/buster-fast-bench/exclusive.sh "${@:2}" >> "$dir/head-queue.log" 2>&1; }
{
    uname -a
    clang --version | head -1
    echo "cpu2 governor: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    echo "thp: $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
    echo "hypervisor flags: $(grep -c -w hypervisor /proc/cpuinfo)"
    grep -E '^(MemTotal|MemAvailable):' /proc/meminfo
} > "$env"
for tree in a4a2182a 08cf75ce; do
    (cd "$dir/$tree" && lock "build $tree" bash -c './build.sh > build.log 2>&1; echo "build.sh status $?" >> build.log') 
    {
        echo "$tree: COMMIT $(cat "$dir/$tree/COMMIT")"
        (cd "$dir" && sha256sum "$tree/build/compiler")
        grep -E '^build.sh' "$dir/$tree/build.log"
    } >> "$env"
    [ -x "$dir/$tree/build/compiler" ] || { echo "build $tree failed" >> "$units"; exit 1; }
done
for round in 1 2; do
    lock "-c main default round $round" "$dir/units-run.sh" "$dir/a4a2182a" "$units" main-default
    lock "-c head default round $round" "$dir/units-run.sh" "$dir/08cf75ce" "$units" head-default
    lock "-c head 12g round $round" "$dir/units-run.sh" "$dir/08cf75ce" "$units" head-12g --units-memory=12884901888
    lock "-c head 6g round $round" "$dir/units-run.sh" "$dir/08cf75ce" "$units" head-6g --units-memory=6442450944
    lock "link main default round $round" "$dir/units-link.sh" "$dir/a4a2182a" "$link" main-link-default
    lock "link head default round $round" "$dir/units-link.sh" "$dir/08cf75ce" "$link" head-link-default
    lock "link head 12g round $round" "$dir/units-link.sh" "$dir/08cf75ce" "$link" head-link-12g --units-memory=12884901888
done
echo "queue done" >> "$units"
echo "queue done" >> "$link"
