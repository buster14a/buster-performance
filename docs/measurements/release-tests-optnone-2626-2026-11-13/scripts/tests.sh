#!/bin/bash
# The run time of the design's 21 test commands (scripts/tests.list, from stage1-build-design-2040's record) by one
# side's executable (placement 0), inside the lock: tests.sh SIDE ROUND. Each runs once from the base tree; its wall,
# user and system time and status go to results/tests/SIDE.ROUND.tsv.
set -u
export LC_ALL=C
side=$1; round=$2
d=$HOME/buster-fast-bench/2626-claude
. "$d/scripts/env.sh"
mkdir -p "$d/results/tests" "$d/logs/tests"
head -1 /var/lib/buster-9700x/owner > "$d/results/tests/$side.$round.holder.txt"
cd "$d/base" || exit 2
unset CPATH C_INCLUDE_PATH
compiler=$d/placements/$side/compiler-0
export BUSTER_COMPILER=$compiler
TIMEFORMAT='%R %U %S'
index=0
while IFS= read -r line; do
    index=$((index + 1))
    # shellcheck disable=SC2086
    { time timeout 540 "$compiler" $line > "$d/logs/tests/$side.$round.$index.log" 2>&1; } 2> "$d/logs/tests/$side.$round.$index.time"
    rc=$?
    printf '%s\t%s\t%s\trc=%s\n' "$index" "$line" "$(tail -1 "$d/logs/tests/$side.$round.$index.time")" "$rc" >> "$d/results/tests/$side.$round.tsv"
done < "$d/scripts/tests.list"
