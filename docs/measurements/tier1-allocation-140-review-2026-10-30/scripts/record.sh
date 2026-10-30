#!/bin/bash
# The #140 review's measurements: builds, runs and receipts, in three holds of the host's lock (LOCK, the 9700X's
# exclusive.sh by default): the builds, the timed runs (about a minute) and LLVM's compiles. Each step writes its own
# log with its start, end and exit status; the lock's own messages go to OUT/lock/ and are not published. Timed runs
# are pinned to CPU 2.
# Usage: record.sh BUSTER_TREE SQLITE3_C WORK OUT
#   BUSTER_TREE: `git archive` of the measured buster commit, with a COMMIT file.
# record.sh --group NAME BUSTER_TREE SQLITE3_C WORK OUT runs one group's steps; the caller holds the lock.
set -u
here=$(cd "$(dirname "$0")" && pwd)
flags=(-O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wno-unused-function)

# step NAME COMMAND...: the command's output, start, end and exit status in OUT/NAME.log.
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
    group=$2
    tree=$3; sqlite=$4; work=$5; out=$6
    echo "lock held from $(date -u +%FT%T.%NZ)" > "$out/hold-$group.log"
    case $group in
    builds)
        step build clang "${flags[@]}" -I"$tree/src" -I"$work" "$here/harness.c" -o "$work/harness" -lm
        step build-g clang "${flags[@]}" -g -I"$tree/src" -I"$work" "$here/harness.c" -o "$work/harness-g" -lm
        step build-stream clang "${flags[@]}" "$here/stream.c" -o "$work/stream"
        step build-levels clang "${flags[@]}" "$here/levels.c" -o "$work/levels"
        ;;
    runs)
        for round in 1 2; do
            step "intervals-$round" taskset -c 2 "$work/harness"
        done
        for round in 1 2 3; do
            step "stream-$round" taskset -c 2 "$work/stream"
        done
        for round in 1 2; do
            step "levels-$round" taskset -c 2 "$work/levels"
        done
        for variant in 1 2 3 4; do
            step "levels-perf-$variant" taskset -c 2 perf stat -x, -e cycles:u,instructions:u "$work/levels" "$variant"
        done
        # Where the resolved vector path's time goes: temps-fit, 4,096 intervals (workload 4), configuration 1, 3 s.
        step profile taskset -c 2 perf record -q -e cycles:u -c 200003 -o "$work/perf.data" "$work/harness-g" 4 1 3
        ;;
    llvm)
        # LLVM's register allocation on sqlite3.c at -O2 (greedy) and -O0 (fast), and its static spill counts at -O2.
        step llvm-O2 bash -c 'taskset -c 2 clang -O2 -c "$1" -o "$2/sqlite-O2.o" -ftime-report && echo "instructions: $(objdump -d --no-show-raw-insn "$2/sqlite-O2.o" | grep -c -E "^ +[0-9a-f]+:")"' llvm "$sqlite" "$work"
        step llvm-O0 bash -c 'taskset -c 2 clang -O0 -c "$1" -o "$2/sqlite-O0.o" -ftime-report && echo "instructions: $(objdump -d --no-show-raw-insn "$2/sqlite-O0.o" | grep -c -E "^ +[0-9a-f]+:")"' llvm "$sqlite" "$work"
        step llvm-O2-asm bash -c 'taskset -c 2 clang -O2 -S "$1" -o "$2/sqlite-O2.s" && echo "spills: $(grep -c -E "# [0-9]+-byte Spill" "$2/sqlite-O2.s"), reloads: $(grep -c -E "# [0-9]+-byte Reload" "$2/sqlite-O2.s"), folded reloads: $(grep -c -E "# [0-9]+-byte Folded Reload" "$2/sqlite-O2.s")"' llvm "$sqlite" "$work"
        ;;
    esac
    echo "lock released at $(date -u +%FT%T.%NZ)" >> "$out/hold-$group.log"
    exit 0
fi

tree=$1; sqlite=$2; work=$3; out=$4
lock=${LOCK:-$HOME/buster-fast-bench/exclusive.sh}
export EXCLUSIVE_OWNER=claude-140-review EXCLUSIVE_TITLE="#140 review record" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
mkdir -p "$work" "$out/lock"
{
    uname -a
    grep -m1 'model name' /proc/cpuinfo
    clang --version | head -1
    perf --version
    printf 'cpu2 governor: %s, energy preference: %s\n' "$(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor)" "$(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    printf 'buster commit: %s\n' "$(cat "$tree/COMMIT")"
} > "$out/host.txt" 2>&1
(cd "$tree" && find . -type f | LC_ALL=C sort | xargs sha256sum) > "$out/tree.sha256"
(cd "$here" && sha256sum *.c *.sh *.awk) > "$out/record-files.sha256"
sha256sum "$sqlite" > "$out/inputs.sha256"
"$here/make_proto.sh" "$tree/src/buster/compiler/tier1_allocate.c" "$work/proto_impl.c"
sha256sum "$work/proto_impl.c" >> "$out/record-files.sha256"

for group in builds runs llvm; do
    "$lock" "$here/record.sh" --group "$group" "$tree" "$sqlite" "$work" "$out" > "$out/lock/$group.log" 2>&1
    if [ "$group" = builds ]; then
        sha256sum "$work/harness" "$work/harness-g" "$work/stream" "$work/levels" > "$out/executables.sha256"
    fi
done
perf report -i "$work/perf.data" --sort srcline --stdio 2> /dev/null | grep '%' | awk -f "$here/phases.awk" | sort -k2 > "$out/profile-phases.txt"
objdump -d -l --no-show-raw-insn "$work/harness-g" | awk '/<proto_allocate_impl>:/ { inside = 1 } /^[0-9a-f]+ <.*>:/ { if ($0 !~ /proto_allocate_impl/) inside = 0 } inside' | awk '/proto_impl.c:12[0-4]/ { keep = 1; sub(".*/", ""); print; next } /proto_impl.c:/ { keep = 0 } keep' > "$out/placement-loop.txt"
echo "record done"
