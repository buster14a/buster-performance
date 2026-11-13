#!/bin/bash
# Profile one driver part under a sanitizer build: time it, then perf record it (no call graph), CI's runtime options.
set -u
tree=$HOME/buster-fast-bench/2639-claude/split
build=${1:?build}
part=${2:?part}
out=${3:?out dir}
mkdir -p "$out/reports"
reports="$out/reports"
symbolizer=$(command -v llvm-symbolizer)
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
exe=$tree/build/cmake/$build/Release/compiler
cd "$tree"
TIMEFORMAT='%R %U %S'
{ time taskset -c 4 perf record -q -F 499 -o "$out/perf.data" -- "$exe" test-checker-driver --executable "$exe" --part "$part" --in-process > "$out/stdout.txt" 2> "$out/stderr.txt"; } 2> "$out/time.txt"
echo "status=$? time=$(cat "$out/time.txt")"
perf report -i "$out/perf.data" --no-children --sort dso -q 2>/dev/null | head -15 > "$out/dso.txt"
perf report -i "$out/perf.data" --no-children --sort comm,dso,symbol -q 2>/dev/null | head -60 > "$out/symbols.txt"
cat "$out/dso.txt"; head -40 "$out/symbols.txt"
tail -3 "$out/stdout.txt"
ls "$reports" | head -3
