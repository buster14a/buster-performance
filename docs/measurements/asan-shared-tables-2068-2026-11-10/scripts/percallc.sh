#!/bin/bash
# percallc.sh LABEL COMPILER N [ASAN_OVERRIDES]: N `-c small.c` compiles under CI's options.
set -u
export LC_ALL=C
label=$1; compiler=$2; n=$3; overrides=${4:-}
out=$HOME/.cache/claude-pr2056-review/2030
reports=$(mktemp -d "$out/pc.XXXX")
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report${overrides:+:$overrides}"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:log_path=$reports/report"
TIMEFORMAT='%R %U %S'
[ -x "$compiler" ] || { echo "$label: no $compiler"; exit 1; }
t=$( { time for ((i = 0; i < n; i++)); do env -u CPATH "$compiler" -c "$out/small.c" -o "$reports/small.o" || echo FAIL; done; } 2>&1 )
echo "$label -c n=$n $t per-call-ms=$(echo "$t" | tail -1 | awk -v n=$n '{printf "%.2f", 1000*$1/n}') reports=$(ls "$reports" | grep -c report)"
