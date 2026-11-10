#!/bin/bash
# Where part 13's driver process works alone for long under ASan: a fresh run by the rebuilt compiler with only its
# execve calls traced (strace's seccomp filter, so the rest runs untraced), bounded by `timeout`; then the longest gaps
# between consecutive execs, with the commands on either side.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
seconds=${1:-900}
cd "${DRIVER_TREE:-/home/david/dev/ai/claude/buster/.claude/worktrees/asan-driver-2030}" || exit 2
reports=$(mktemp -d "$D/gaps.XXXX")
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:log_path=$reports/report"
timeout -s INT "$seconds" strace -f --seccomp-bpf -e trace=execve -e signal=none -qq -ttt -s 120 -o "$D/p${2:-13}-execs.txt" \
    "$D/tools/nothp" env -u CPATH "$D/compiler-fixed4" test-checker-driver --executable "$D/compiler-fixed4" --part "${2:-13}/16" \
    > "$D/p${2:-13}-gaps.log" 2>&1
grep 'execve(' "$D/p${2:-13}-execs.txt" | grep -v ENOENT | awk '{ t = $2; if (NR > 1) printf "%.1f %s | %s\n", t - last, prev, substr($0, 1, 400); last = t; prev = substr($0, 1, 400) }' \
    | sort -rn | head -12 > "$D/p${2:-13}-gaps.txt"
