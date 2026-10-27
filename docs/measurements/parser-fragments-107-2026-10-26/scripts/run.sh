#!/usr/bin/env bash
# #106/#107 on the 9700X: build, identity, benchmarks; every step under its own lock acquisition, pinned to CPU 2.
set -u
base=~/buster-fast-bench/claude-fragments-106-107
tree=$base/tree-${TREE:-47276329}
inputs=$base/inputs
results=$base/results-${TREE:-47276329}
mkdir -p "$results"
export EXCLUSIVE_OWNER=claude-fragments-107
export EXCLUSIVE_TITLE="Salter fragments #106/#107: consumer identity and four-path measurement"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/107
lock=~/buster-fast-bench/exclusive.sh
step()
{
    local name="$1"
    shift
    echo "$(date -Is) start $name" >> "$results/progress"
    ( cd "$tree" && "$lock" "$@" ) > "$results/$name.log" 2>&1
    echo "$(date -Is) end $name status $?" >> "$results/progress"
}
{
    date -Is
    uname -a
    clang --version | head -1
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null
    (cd "$tree" && git -C . rev-parse HEAD 2>/dev/null || echo "tree ${TREE:-47276329} (git archive)")
} > "$results/environment.txt"
if [ "${SKIP_BUILD:-0}" != 1 ]; then
    step build bash -c './build.sh && sha256sum build/compiler'
fi
c=./build/compiler
pin="taskset -c 2"
if [ "${SKIP_IDENTITY:-0}" != 1 ]; then
    step identity-fixtures $pin $c test-fragments
    step identity-checker-fixtures $pin $c test-fragments --no-fixtures --checker-fixtures
    step identity-sqlite bash -c "sha256sum --quiet --check $inputs/sqlite3.sha256 && cd $inputs && $pin $tree/build/compiler test-fragments --no-fixtures sqlite3.c"
    step identity-generated bash -c "cd $inputs && sha256sum --quiet --check generated.sha256 && $pin $tree/build/compiler test-fragments --no-fixtures long_expressions.c small_functions.c"
    split -n l/4 -d "$inputs/libc.txt" "$results/libc-chunk-"
    for chunk in "$results"/libc-chunk-*; do
        step "identity-libc-$(basename "$chunk")" bash -c "sha256sum --quiet --check $inputs/libc.sha256 && $pin $tree/build/compiler test-fragments --no-fixtures --files-from $chunk"
    done
fi
if [ "${SKIP_BENCHMARK:-0}" != 1 ]; then
    b="$pin $c benchmark-parser --expressions all --passes 21"
    for i in 1 2 3 4 5; do
        step "bench-sqlite-pipeline-$i" bash -c "sha256sum --quiet --check $inputs/sqlite3.sha256 && $b --counters pipeline $inputs/sqlite3.c"
    done
    for i in 1 2; do
        step "bench-sqlite-branches-$i" bash -c "$b --counters branches $inputs/sqlite3.c"
    done
    step bench-sqlite-stalls-1 bash -c "$b --counters stalls $inputs/sqlite3.c"
    step bench-sqlite-memory-1 bash -c "$b --counters memory $inputs/sqlite3.c"
    step bench-sqlite-scalar-1 bash -c "$b --interleave scalar $inputs/sqlite3.c"
    step bench-sqlite-payload48-1 bash -c "$b --payload 48 $inputs/sqlite3.c"
    for i in 1 2; do
        step "bench-sqlite-ir-$i" bash -c "$b --to-ir $inputs/sqlite3.c"
    done
    for i in 1 2 3; do
        step "bench-libc-pipeline-$i" bash -c "sha256sum --quiet --check $inputs/libc.sha256 && $b --counters pipeline --files-from $inputs/libc.txt"
    done
    step bench-libc-branches-1 bash -c "$b --counters branches --files-from $inputs/libc.txt"
    for i in 1 2 3; do
        step "bench-long-$i" bash -c "$b $inputs/long_expressions.c"
        step "bench-small-$i" bash -c "$b $inputs/small_functions.c"
    done
fi
echo "$(date -Is) done" >> "$results/progress"
