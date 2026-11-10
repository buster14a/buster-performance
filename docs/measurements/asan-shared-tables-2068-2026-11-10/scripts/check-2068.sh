#!/bin/bash
# #2068's ASan build against #2067's (compiler-fixed4): per-process small -c compiles alternating, with and without THP;
# driver part 1/16 side by side on two cores, without THP; then units of their own that read the shared tables under
# ASan with CI's options: measure-tier1-model --verify (a correctness command), the encoder benchmark in each mode, the
# semantics benchmark, and test-baked-tables. Every run is bounded.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
cpus=${CORES_CPUS:-2,10,3,11}
first=$(echo "$cpus" | cut -d, -f1)
second=$(echo "$cpus" | cut -d, -f3)
cd "$D" || exit 2
{
    for r in 1 2; do
        taskset -c "$first" ./percallc.sh "r$r-2067" ./compiler-fixed4 40
        taskset -c "$first" ./percallc.sh "r$r-2068" ./compiler-2068 40
        taskset -c "$first" ./tools/nothp ./percallc.sh "r$r-nothp-2067" ./compiler-fixed4 40
        taskset -c "$first" ./tools/nothp ./percallc.sh "r$r-nothp-2068" ./compiler-2068 40
    done
} > "$D/percall-2068.txt" 2>&1
export DRIVER_TREE=/home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500
for r in 1 2; do
    timeout 900 taskset -c "$first" "$D/driver.sh" "ab2068-$r-2067" "$D/compiler-fixed4" 1/16 "" "" nothp &
    timeout 900 taskset -c "$second" "$D/driver.sh" "ab2068-$r-2068" "$D/compiler-2068" 1/16 "" "" nothp &
    wait
done
reports=$(mktemp -d "$D/units.XXXX")
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:log_path=$reports/report"
cd "$DRIVER_TREE" || exit 2
run() { local label=$1; shift; timeout 900 taskset -c "$first" env -u CPATH "$D/compiler-2068" "$@" > "$D/units-$label.log" 2>&1; echo "$label rc=$? | $(tail -1 "$D/units-$label.log" | cut -c1-140)"; }
{
    run baked test-baked-tables
    timeout 900 taskset -c "$first" env -u CPATH "$D/compiler-2068" test-tier1-select --manifest > "$D/tier1-plan-manifest.csv" 2> "$D/units-manifest.log"
    echo "manifest rc=$? | $(wc -l < "$D/tier1-plan-manifest.csv") lines"
    run model measure-tier1-model --manifest "$D/tier1-plan-manifest.csv" --verify
    run encoder benchmark-x86-encoder --count 4096
    run encoder32 benchmark-x86-encoder --count 4096 --mode32
    run encoder16 benchmark-x86-encoder --count 4096 --mode16
    run semantics benchmark-x86-semantics --requests 4096 --functions 256
    echo "sanitizer reports: $(ls "$reports" | wc -l)"
} > "$D/units-2068.txt"
cat "$D/percall-2068.txt" | cut -c1-110
grep '^ab2068-' "$D/driver.txt" | cut -c1-110
cat "$D/units-2068.txt"
