#!/bin/bash
# Which string interceptors part 13 calls, and from where: hardware execute breakpoints on four interceptors of the
# fixed-address ASan build (one sample per 200 calls, frame-pointer stacks from the caller), for 60 seconds of the run,
# children included. part13-bp.sh LABEL NAME=ADDRESS...
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
label=$1; shift
events=()
for pair in "$@"; do
    events+=(-e "mem:${pair#*=}:x")
done
cd /home/david/dev/ai/claude/buster/.claude/worktrees/asan-driver-2030 || exit 2
reports=$(mktemp -d "$D/p13.XXXX")
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:log_path=$reports/report"
timeout -s INT 60 perf record -q "${events[@]}" -c 200 -g -o "$D/p13-bp-$label.data" -- env -u CPATH "$D/compiler-fixed" \
    test-checker-driver --executable "$D/compiler-fixed" --part 13/16 > "$D/p13-bp-$label.log" 2>&1
perf report -i "$D/p13-bp-$label.data" --stdio --sort sym -g caller,0.5,callee --percent-limit 2 -q 2> /dev/null | grep -v '^$' | head -150 > "$D/p13-bp-$label.txt"
perf report -i "$D/p13-bp-$label.data" --stdio --sort sym -g none -q 2> /dev/null | grep -v '^$' | head -20 >> "$D/p13-bp-$label.txt"
