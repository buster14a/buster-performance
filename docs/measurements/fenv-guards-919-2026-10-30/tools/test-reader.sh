#!/bin/sh
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Original local parser controls; no compiler measurements or hardware jobs.
set -eu
if [ "$#" -ne 2 ]; then
    echo 'usage: test-reader.sh TOOLS_DIRECTORY NEW_RESULTS_DIRECTORY' >&2
    exit 1
fi
tools=$1
results=$2
mkdir "$results"
printf 'mode,reader,status,output_bytes\n' > "$results/controls.csv"
for mode in valid valid-producer valid-wide-summary valid-reversed wrong-reference missing-record duplicate-record nonzero-status zero-wall zero-cycles zero-instructions missing-file warning failed-done missing-done extra-file overflow-run overflow-status overflow-counters overflow-cycles overflow-instructions signed-range-counter run-tab unknown-text trailing-text; do
    mkdir "$results/$mode"
    "$tools/write-reader-fixtures" "$results/$mode" "$mode"
    for reader in read-results read-results-sanitize; do
        status=0
        "$tools/$reader" "$results/$mode" > "$results/$mode/$reader.csv" 2> "$results/$mode/$reader.stderr" || status=$?
        bytes=$(wc -c < "$results/$mode/$reader.csv")
        printf '%s,%s,%s,%s\n' "$mode" "$reader" "$status" "$bytes" >> "$results/controls.csv"
        if [ "$mode" = valid ] || [ "$mode" = valid-producer ] || [ "$mode" = valid-wide-summary ] || [ "$mode" = valid-reversed ]; then
            [ "$status" -eq 0 ]
            [ ! -s "$results/$mode/$reader.stderr" ]
            awk -F, '
                NR == 1 { if (NF != 18) exit 1; next }
                { if (NF != 18 || $5 != 2 || $6 != 42) exit 1;
                  if ($4 == "base") {
                      if ($7 != 1061000 || $8 != 1061 || $9 != 2061 || $10 != 1011000 || $11 != 1111000 || $12 != 1011 || $13 != 1111 || $14 != 2011 || $15 != 2111 || $16 != 0 || $17 != 0 || $18 != 0) exit 1;
                  } else if ($4 == "head") {
                      if ($7 != 561000 || $8 != 961 || $9 != 1861 || $10 != 511000 || $11 != 611000 || $12 != 911 || $13 != 1011 || $14 != 1811 || $15 != 1911) exit 1;
                      wall = 100 * (561000 / 1061000 - 1); cycles = 100 * (961 / 1061 - 1); instructions = 100 * (1861 / 2061 - 1);
                      if (($16 - wall)^2 > 1e-16 || ($17 - cycles)^2 > 1e-16 || ($18 - instructions)^2 > 1e-16) exit 1;
                  } else exit 1;
                }
                END { if (NR != 55) exit 1 }
            ' "$results/$mode/$reader.csv"
        else
            [ "$status" -eq 1 ]
            [ "$bytes" -eq 0 ]
            ! rg -q 'ERROR: AddressSanitizer|runtime error:' "$results/$mode/$reader.stderr"
        fi
    done
done
"$tools/read-results" "$results/valid" --samples > "$results/samples.csv"
awk -F, 'NR == 1 { if (NF != 9) exit 1; next } { if (NF != 9 || $5 < 1 || $5 > 2 || $6 < 1 || $6 > 21 || $7 <= 0 || $8 <= 0 || $9 <= 0) exit 1 } END { if (NR != 2269) exit 1 }' "$results/samples.csv"
for reader in read-results read-results-sanitize; do
    status=0
    "$tools/$reader" > "$results/$reader-no-arguments.csv" 2> "$results/$reader-no-arguments.stderr" || status=$?
    [ "$status" -eq 1 ]
    [ ! -s "$results/$reader-no-arguments.csv" ]
    status=0
    "$tools/$reader" "$results/valid" --unknown > "$results/$reader-invalid-option.csv" 2> "$results/$reader-invalid-option.stderr" || status=$?
    [ "$status" -eq 1 ]
    [ ! -s "$results/$reader-invalid-option.csv" ]
done
printf 'positive median/sample checks and all negative controls passed\n'
