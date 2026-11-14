#!/bin/bash
# An eight-CPU heading's command in the hosted shape (taskset CPUS), alone as the runner runs it (holding every CPU) or
# beside BURNERS single-threaded CPU-bound processes on the same CPUs, as it would run holding fewer; CI's sanitizer
# options, timed.
#   run-shared.sh TREE OUT EXECUTABLE CPUS GRANT BURNERS COMMAND...
set -u
tree=${1:?tree}
out=$(realpath -m "${2:?out}")
exe=${3:?executable}
cpus=${4:?cpus}
grant=${5:?grant}
burners=${6:?burners}
shift 6
mkdir -p "$out/reports"
reports="$out/reports"
symbolizer=$(command -v llvm-symbolizer)
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
export BUSTER_ORACLE_CACHE=check XDG_CACHE_HOME="$out/cache" BUSTER_COMPILER="$exe" BUSTER_PARALLEL_CPUS="$grant"
cd "$tree"
pids=()
for i in $(seq "$burners"); do
    taskset -c "$cpus" sh -c 'while :; do :; done' &
    pids+=($!)
done
TIMEFORMAT='%R %U %S'
{ time taskset -c "$cpus" "$@" > "$out/stdout.txt" 2> "$out/stderr.txt"; } 2> "$out/time.txt"
status=$?
for p in "${pids[@]}"; do kill "$p"; done
wait 2>/dev/null
echo "status=$status burners=$burners time(real user sys)=$(cat "$out/time.txt") reports=$(ls "$reports" | wc -l) :: $*"
exit $status
