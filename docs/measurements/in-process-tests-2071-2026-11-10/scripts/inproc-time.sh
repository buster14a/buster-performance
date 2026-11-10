#!/bin/bash
# #2071's timing: parts 6, 7 and 8 of test-checker-driver (the warning sweep's) by COMPILER, as children and with
# --in-process --clang-server, at the same time on two cores of the grant, each bounded. inproc-time.sh LABEL COMPILER
# [nothp]: one line per part and mode, with its wall time and the sweep's own.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
label=$1; compiler=$2; thp=${3:-}
tree=/home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500
server=$tree/build/clang-server/clang-server
first=$(echo "${CORES_CPUS:-2,10,3,11}" | cut -d, -f1)
second=$(echo "${CORES_CPUS:-2,10,3,11}" | cut -d, -f3)
cd "$tree" || exit 2
wrapper=()
[ "$thp" = nothp ] && wrapper=("$D/tools/nothp")
reports=$(mktemp -d "$D/inproc.XXXX")
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:log_path=$reports/report"
TIMEFORMAT='%R'
run()
{
    local cpu=$1 mode=$2 part=$3
    shift 3
    local log="$D/inproc/time-$label-$mode-$part.log"
    local wall
    wall=$( { time timeout 3600 taskset -c "$cpu" "${wrapper[@]}" env -u CPATH "$compiler" test-checker-driver --executable "$compiler" \
        --part "$part/16" "$@" > "$log" 2>&1; } 2>&1 )
    echo "$label $mode part=$part wall=$wall | $(grep -o 'warning sweep: .*' "$log" | cut -c1-120) | $(tail -1 "$log")"
}
for part in 6 7 8; do
    run "$first" children "$part" &
    run "$second" fast "$part" --in-process --clang-server "$server" &
    wait
done
echo "$label: sanitizer reports $(ls "$reports" | wc -l)"
