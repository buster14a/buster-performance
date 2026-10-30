#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Historical report copies are parser fixtures, never current campaign evidence.
set -euo pipefail
reader=$(realpath -- "${1:?usage: stage-summary-controls.sh STAGE_READER HISTORICAL_TEMPLATE NEW_OUTPUT}")
template=$(realpath -- "${2:?}")
output=${3:?}
test ! -e "$output"
mkdir -p "$output/good"
output=$(realpath -- "$output")
source_dir=$(cd -- "$(dirname -- "$0")" && pwd)
sha256sum "$reader" "$template" "$source_dir/stage_summary.c" "$source_dir/stage-summary-controls.sh" > "$output/before-tests.sha256"
for role in base head; do
    for process in 1 2 3; do
        for shift in 0 64 256; do
            cp "$template" "$output/good/stages-$role-p$process-s$shift.log"
        done
    done
done
"$reader" "$output/good" > "$output/good.csv" 2> "$output/good.stderr"
test "$(wc -l < "$output/good.csv")" = 10
printf 'complete18-grid expected_exit=0 PASS\n'
for mode in missing-file extra-file duplicate-run missing-run wrong-run wrong-count wrong-median unknown-stage duplicate-stage missing-stage object-failure missing-terminal appended-error nan signed truncated; do
    directory="$output/$mode"
    cp -a "$output/good" "$directory"
    target="$directory/stages-base-p1-s0.log"
    case "$mode" in
        missing-file) rm "$target" ;;
        extra-file) cp "$template" "$directory/stages-base-p4-s0.log" ;;
        duplicate-run) sed '/^run 1 default:/p' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        missing-run) sed '/^run 21 reference:/d' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        wrong-run) sed 's/^run 21 reference:/run 22 reference:/' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        wrong-count) sed 's/21 runs, reference/20 runs, reference/' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        wrong-median) sed 's/^default: median of 21: [0-9.]*/default: median of 21: 0.001/' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        unknown-stage) sed 's/^  check-input /  unknown-check /' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        duplicate-stage) sed '/^  check-input /p' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        missing-stage) sed '/^  check-input /d' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        object-failure) sed "s/^measure-compile: 0 failures$/run 21: FAILED (the default's object is not staged)/" "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        missing-terminal) sed '/^measure-compile: 0 failures$/d' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        appended-error) printf 'error: synthetic failure\n' >> "$target" ;;
        nan) sed 's/^run 1 default: [0-9.]*/run 1 default: nan/' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        signed) sed 's/^run 1 default: /run 1 default: +/' "$target" > "$target.tmp"; mv "$target.tmp" "$target" ;;
        truncated) truncate -s -1 "$target" ;;
    esac
    actual=0
    "$reader" "$directory" > "$output/$mode.csv" 2> "$output/$mode.stderr" || actual=$?
    test "$actual" = 1
    test ! -s "$output/$mode.csv"
    printf '%s expected_exit=1 actual_exit=%s no_partial_csv=PASS\n' "$mode" "$actual"
done
sha256sum --check "$output/before-tests.sha256" > "$output/after-tests-check.txt"
printf 'Stage reader positive and16 negative controls passed; source/tool/template identities unchanged.\n'
