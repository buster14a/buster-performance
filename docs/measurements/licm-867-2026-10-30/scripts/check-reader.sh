#!/usr/bin/env bash
set -euo pipefail
reader=$1
source_logs=$2
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT
"$reader" "$source_logs" "$temporary/rows.csv" "$temporary/summary.csv"
test "$(wc -l < "$temporary/rows.csv")" -eq 577
test "$(wc -l < "$temporary/summary.csv")" -eq 25
printf 'complete source grid: accepted576 rows and24 groups\n'
reject()
{
    local label=$1
    if "$reader" "$temporary/logs" "$temporary/$label-rows.csv" "$temporary/$label-summary.csv"; then
        printf 'incorrectly accepted %s\n' "$label" >&2
        exit 1
    fi
    printf '%s: rejected\n' "$label"
    rm -rf "$temporary/logs"
}
cp -a "$source_logs" "$temporary/logs"
rm "$temporary/logs/source-base-shift0-process1-loop.log" "$temporary/logs/source-head-shift0-process1-loop.log"
reject missing-pair
cp -a "$source_logs" "$temporary/logs"
rm "$temporary/logs/source-base-shift0-process1-loop.log"
reject orphan-candidate
cp -a "$source_logs" "$temporary/logs"
sed -i 's/ir-pass licm no-loop scalar samples=/ir-pass licm no-loop vector samples=/' "$temporary/logs/source-base-shift0-process1-loop.log"
reject duplicate-key
cp -a "$source_logs" "$temporary/logs"
sed -i 's/ ns=[^ ]*/ ns=nan/' "$temporary/logs/source-base-shift0-process1-loop.log"
reject nonfinite-median
cp -a "$source_logs" "$temporary/logs"
sed -i 's/state=source-loop/state=source-unknown/' "$temporary/logs/source-base-shift0-process1-loop.log"
reject unknown-state
