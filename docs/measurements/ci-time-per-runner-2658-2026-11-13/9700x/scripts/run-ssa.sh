#!/bin/bash
# One inventory command of test-ssa-source as the hosted runner's parallel runner starts it: pinned to CPUS (taskset),
# BUSTER_PARALLEL_CPUS=GRANT, CI's sanitizer options, the oracle cache in check mode with a fresh cache, timed.
#   run-ssa.sh TREE OUT EXECUTABLE compare|random|lifetimes CPUS GRANT
set -u
tree=${1:?tree}
out=$(realpath -m "${2:?out}")
exe=${3:?executable}
kind=${4:?kind}
cpus=${5:?cpus}
grant=${6:?grant}
mkdir -p "$out/reports" "$out/cache"
reports="$out/reports"
symbolizer=$(command -v llvm-symbolizer)
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
export BUSTER_ORACLE_CACHE=check XDG_CACHE_HOME="$out/cache" BUSTER_COMPILER="$exe" BUSTER_PARALLEL_CPUS="$grant"
cd "$tree"
case "$kind" in
    compare) mapfile -t files < <(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
             args=(test-ssa-source --typed --tier1 "${files[@]}") ;;
    random) args=(test-ssa-source --typed --tier1 --generate 48 --clang clang) ;;
    lifetimes) args=(test-ssa-source --tier1 --generate 24 --seed 141 --lifetimes --clang clang) ;;
    *) echo "unknown kind $kind"; exit 2 ;;
esac
uptime > "$out/before.txt"
TIMEFORMAT='%R %U %S'
{ time taskset -c "$cpus" "$exe" "${args[@]}" > "$out/stdout.txt" 2> "$out/stderr.txt"; } 2> "$out/time.txt"
status=$?
uptime > "$out/after.txt"
echo "status=$status time(real user sys)=$(cat "$out/time.txt") reports=$(ls "$reports" | wc -l)"
grep "totals\|oracle cache" "$out/stdout.txt" | cut -c1-300
exit $status
