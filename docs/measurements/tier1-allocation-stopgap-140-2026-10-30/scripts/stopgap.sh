#!/bin/bash
# Main against head for buster #140's stopgap, in four holds of the host's lock (LOCK, the 9700X's exclusive.sh by
# default): the builds, head's tests and main's allocation test, the benchmark's plain and isolated runs, and its
# runs after scalar work. Each step writes its own log with start, end and exit status; the lock's own messages go
# to OUT/lock/, which is not published. Timed runs are pinned to CPU 2, alternating which tree goes first.
# Usage: stopgap.sh MAIN_TREE HEAD_TREE WORK OUT   (each tree: `git archive` of a commit, with a COMMIT file)
# stopgap.sh --group NAME MAIN_TREE HEAD_TREE WORK OUT runs one group; the caller holds the lock.
set -u
here=$(cd "$(dirname "$0")" && pwd)

step()
{
    local name=$1
    shift
    {
        echo "started $(date -u +%FT%T.%NZ)"
        "$@"
        local status=$?
        echo "ended $(date -u +%FT%T.%NZ), exit $status"
    } > "$out/$name.log" 2>&1
}

if [ "$1" = --group ]; then
    group=$2; main=$3; head=$4; work=$5; out=$6
    echo "lock held from $(date -u +%FT%T.%NZ)" > "$out/hold-$group.log"
    case $group in
    builds)
        for tree in main head; do
            dir=$main; [ $tree = head ] && dir=$head
            step "build-$tree" bash -c 'cd "$1" && BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh' build "$dir"
        done
        for tree in main head; do
            src=$main/src; [ $tree = head ] && src=$head/src
            step "build-differential-$tree" clang -O2 -march=native -I"$src" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wno-unused-function "$here/differential.c" -o "$work/differential-$tree"
        done
        ;;
    tests)
        step test-main-tier1-allocation "$main/build/compiler" test-tier1-allocation
        step test-head-tier1-allocation "$head/build/compiler" test-tier1-allocation
        step test-head-tier1-allocation-seed7 "$head/build/compiler" test-tier1-allocation --seed 7 --count 4000
        step test-head-tier1-allocation-seed99 "$head/build/compiler" test-tier1-allocation --seed 99 --count 4000
        step test-head-tier1-liveness "$head/build/compiler" test-tier1-liveness
        step test-head-tier1-emit "$head/build/compiler" test-tier1-emit
        step test-head-tier1-frame "$head/build/compiler" test-tier1-frame
        step test-head-tier1-pipeline "$head/build/compiler" test-tier1-pipeline --cross-check
        for tree in main head; do
            step "differential-$tree" "$work/differential-$tree"
        done
        ;;
    bench)
        for round in 1 2 3 4 5; do
            order="main head"; [ $((round % 2)) = 0 ] && order="head main"
            for tree in $order; do
                dir=$main; [ $tree = head ] && dir=$head
                step "bench-$round-$tree-plain" taskset -c 2 "$dir/build/compiler" benchmark-tier1-allocation
                step "bench-$round-$tree-vector" taskset -c 2 "$dir/build/compiler" benchmark-tier1-allocation --only vector
                step "bench-$round-$tree-scalar" taskset -c 2 "$dir/build/compiler" benchmark-tier1-allocation --only scalar
            done
        done
        ;;
    after)
        for round in 1 2 3; do
            order="main head"; [ $((round % 2)) = 0 ] && order="head main"
            for tree in $order; do
                dir=$main; [ $tree = head ] && dir=$head
                step "bench-$round-$tree-after" taskset -c 2 "$dir/build/compiler" benchmark-tier1-allocation --only vector --after-scalar 100
            done
        done
        ;;
    esac
    echo "lock released at $(date -u +%FT%T.%NZ)" >> "$out/hold-$group.log"
    exit 0
fi

main=$1; head=$2; work=$3; out=$4
lock=${LOCK:-$HOME/buster-fast-bench/exclusive.sh}
export EXCLUSIVE_OWNER=claude-140-stopgap EXCLUSIVE_TITLE="#140 stopgap: main against head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
mkdir -p "$work" "$out/lock"
{
    uname -a
    grep -m1 'model name' /proc/cpuinfo
    clang --version | head -1
    printf 'cpu2 governor: %s, energy preference: %s\n' "$(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor)" "$(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    printf 'main commit: %s\nhead commit: %s\n' "$(cat "$main/COMMIT")" "$(cat "$head/COMMIT")"
} > "$out/host.txt" 2>&1
for tree in main head; do
    dir=$main; [ $tree = head ] && dir=$head
    (cd "$dir" && find . -type f -not -path './build/*' | LC_ALL=C sort | xargs sha256sum) > "$out/tree-$tree.sha256"
done
(cd "$here" && sha256sum *.c *.sh) > "$out/record-files.sha256"
for group in builds tests bench after; do
    "$lock" "$here/stopgap.sh" --group "$group" "$main" "$head" "$work" "$out" > "$out/lock/$group.log" 2>&1
    if [ "$group" = builds ]; then
        sha256sum "$main/build/compiler" "$head/build/compiler" "$work/differential-main" "$work/differential-head" | sed "s|$(dirname "$main")/||; s|$work/||" > "$out/executables.sha256"
    fi
done
echo "stopgap done"
