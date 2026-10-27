#!/usr/bin/env bash
set -euo pipefail
task_root="$HOME/buster-fast-bench/issue608-20261027"
cd "$task_root/source-final"
export EXCLUSIVE_OWNER=codex-608
export EXCLUSIVE_TITLE='Buster 608 parallel moves qualification'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/608
run()
{
    local label="$1"
    shift
    local status=0
    "$HOME/buster-fast-bench/exclusive.sh" "$@" > "$task_root/logs/$label.log" 2>&1 || status=$?
    printf '%s status=%s\n' "$label" "$status" | tee -a "$task_root/logs/status.log"
    if [ "$status" -ne 0 ]; then
        tail -40 "$task_root/logs/$label.log"
        exit "$status"
    fi
}
if [ "${1-}" != --resume ]; then
    run build-final bash "$task_root/build608.sh"
fi
cat > "$task_root/validation608.list" <<TESTS
== Allocation and parallel moves
./build/compiler test-tier1-allocation --seed 608 --count 4000
== Native emission
./build/compiler test-tier1-emit
== Native pipeline and Clang cross-check
./build/compiler test-tier1-pipeline --cross-check
== Liveness
./build/compiler test-tier1-liveness
== Selection
./build/compiler test-tier1-select
== Compiler call graph [8 CPUs]
env BUSTER_DEBUG_INFO=0 ./build.sh check-call-graph
== Address and undefined behavior sanitizers
env ASAN_OPTIONS=detect_leaks=1 UBSAN_OPTIONS=halt_on_error=1 $task_root/moves-sanitize
TESTS
run validation ./build/compiler parallel --jobs 8 --timeout 180 "$task_root/validation608.list"
for round in 1 2 3; do
    run "benchmark-$round" taskset -c 2 "$task_root/moves-benchmark"
done
{
    date -u
    uname -a
    lscpu
    clang --version
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
    sha256sum "$task_root/moves-benchmark" "$task_root/moves-sanitize" "$task_root/moves_benchmark.c" "$task_root/moves_check.c" src/buster/compiler/tier1_allocate.c src/buster/compiler/tier1_allocate_test.c src/buster/compiler/tier1_moves_test.c build/compiler
} > "$task_root/logs/identity.log"
objdump -d "$task_root/moves-benchmark" > "$task_root/logs/benchmark-assembly.txt"
printf 'complete\n' | tee -a "$task_root/logs/status.log"
