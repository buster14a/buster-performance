#!/bin/bash
# #2071's whole-driver timing: every part of test-checker-driver by COMPILER as children and with --in-process
# --clang-server, a part's two runs at the same time on two cores, PAIRS pairs at once, each bounded.
# time16.sh LABEL COMPILER [nothp]: one line per part and mode, then the sums.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
label=$1; compiler=$2; thp=${3:-}
tree=/home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500
server=$tree/build/clang-server/clang-server
read -r -a cpus <<< "$(echo "${CORES_CPUS:-2,10,3,11,4,12,5,13}" | tr ',' ' ')"
pairs=$(( ${#cpus[@]} / 4 ))
[ "$pairs" -ge 1 ] || pairs=1
cd "$tree" || exit 2
mkdir -p "$D/time16"
reports=$(mktemp -d "$D/time16.XXXX")
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:log_path=$reports/report"
wrapper=()
[ "$thp" = nothp ] && wrapper=("$D/tools/nothp")
one()
{
    local cpu=$1 mode=$2 part=$3
    shift 3
    local log="$D/time16/$label-$mode-$part.log"
    local start end
    start=$(date +%s.%N)
    timeout 5400 taskset -c "$cpu" "${wrapper[@]}" env -u CPATH "$compiler" test-checker-driver --executable "$compiler" --part "$part/16" "$@" > "$log" 2>&1
    local rc=$?
    end=$(date +%s.%N)
    echo "$label $mode part=$part rc=$rc wall=$(echo "$end - $start" | bc) | $(tail -1 "$log")"
}
pair()
{
    local slot=$1 part=$2
    one "${cpus[$((slot * 4))]}" children "$part" &
    one "${cpus[$((slot * 4 + 2))]}" fast "$part" --in-process --clang-server "$server" &
    wait
}
for ((part = 1; part <= 16; part += pairs)); do
    for ((slot = 0; slot < pairs && part + slot <= 16; slot++)); do
        pair "$slot" $((part + slot)) &
    done
    wait
done | tee "$D/time16/$label.txt"
awk '{ split($5, w, "="); sum[$2] += w[2] } END { printf "sums: children %.1f s, fast %.1f s\n", sum["children"], sum["fast"] }' "$D/time16/$label.txt" | tee -a "$D/time16/$label.txt"
echo "sanitizer reports: $(ls "$reports" | wc -l)"
