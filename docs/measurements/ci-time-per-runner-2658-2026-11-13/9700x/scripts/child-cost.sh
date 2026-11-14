#!/bin/bash
# Per-child fixed cost of each sanitizer build: N runs of a tiny -fsyntax-only and -c compile, CI's runtime options.
set -u
tree=$HOME/buster-fast-bench/2639-claude/split
out=${1:?out dir}
n=${2:-40}
mkdir -p "$out/reports"
reports="$out/reports"
symbolizer=$(command -v llvm-symbolizer)
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
printf 'int f(int x) { return x + 1; }\n' > "$out/tiny.c"
TIMEFORMAT='%R %U %S'
for b in native-thread-O3 native-memory-O3 native-address-O3 native-g0; do
    exe=$tree/build/cmake/$b/Release/compiler
    [ -x "$exe" ] || continue
    for mode in syntax c; do
        if [ $mode = syntax ]; then args=(-fsyntax-only "$out/tiny.c"); else args=(-c "$out/tiny.c" -o "$out/tiny.o"); fi
        "$exe" "${args[@]}" || echo "FAIL $b $mode"
        { time (for i in $(seq $n); do taskset -c 4 "$exe" "${args[@]}"; done) ; } 2> "$out/$b-$mode.time"
        printf '%s %s n=%d: %s\n' "$b" "$mode" "$n" "$(cat "$out/$b-$mode.time")"
    done
done
ls "$reports" | head
