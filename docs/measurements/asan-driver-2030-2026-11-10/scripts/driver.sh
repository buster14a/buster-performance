#!/bin/bash
# Times test-checker-driver --part PART with COMPILER under CI's sanitizer options (sanitizers.sh), optionally
# overriding ASAN_OPTIONS entries: driver.sh LABEL COMPILER PART [ASAN_OVERRIDES [LSAN_OVERRIDES [nothp]]].
set -u
export LC_ALL=C
label=$1; compiler=$2; part=$3; overrides=${4:-}; lsan_overrides=${5:-}; wrapper=()
[ "${6:-}" = nothp ] && wrapper=("$HOME/.cache/claude-pr2056-review/2030/tools/nothp")
out=$HOME/.cache/claude-pr2056-review/2030
reports=$out/reports-$label
rm -rf "$reports"; mkdir -p "$reports"
symbolizer=$(command -v llvm-symbolizer)
export ASAN_SYMBOLIZER_PATH="$symbolizer"
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report${overrides:+:$overrides}"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report${lsan_overrides:+:$lsan_overrides}"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
cd "${DRIVER_TREE:-/home/david/dev/ai/claude/buster/.claude/worktrees/asan-driver-2030}" || exit 2
TIMEFORMAT='%R %U %S'
{ time "${wrapper[@]}" env -u CPATH "$compiler" test-checker-driver --executable "$compiler" --part "$part" > "$out/driver-$label.log" 2>&1; } 2> "$out/driver-$label.time"
status=$?
echo "$label part=$part rc=$status $(cat "$out/driver-$label.time") reports=$(ls "$reports" | wc -l) | $(tail -1 "$out/driver-$label.log" | cut -c1-120)" >> "$out/driver.txt"
