#!/bin/bash
# usage: tests.sh NAME COMPILER ROUND ; inside a hold: scripts/tests.list's commands run once each by COMPILER from the
# src clone (BUSTER_COMPILER naming it), their wall, user and system seconds and status to results/tests/NAME.tsv.
# The design's 21 commands (stage1-build-design-2040-2026-11-12's tests.list) and seven whose code is in the units
# BUSTER_SELF_BUILT=tests compiles.
set -u
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
name=$1; compiler=$2; round=$3
out=$d/results/tests
mkdir -p "$out"
cd "$d/src" || exit 2
export BUSTER_COMPILER=$compiler
TIMEFORMAT='%R %U %S'
index=0
while IFS= read -r line; do
    index=$((index + 1))
    # shellcheck disable=SC2086
    { time timeout 600 "$compiler" $line > "$out/$name.$round.$index.log" 2>&1; } 2> "$out/$name.$round.$index.time"
    rc=$?
    printf '%s\t%s\t%s\t%s\trc=%s\n' "$round" "$index" "$line" "$(tail -1 "$out/$name.$round.$index.time")" "$rc" >> "$out/$name.tsv"
done < "$d/scripts/tests.list"
