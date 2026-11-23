#!/usr/bin/env bash
# ledger.sh CAMPAIGN: a line per case of a test-differential campaign directory: the case, its status, its failure
# signature and each step's status, exit code and signal, as the #139 record's ledger.tsv has them.
set -u
campaign=$1
printf 'case\tstatus\tfirst_failure'
steps="buster-tier0-compile buster-tier0-run buster-tier1-compile buster-tier1-run clang-o0-compile clang-o0-run clang-o2-compile clang-o2-run"
for step in $steps; do printf '\t%s' "$step"; done
printf '\n'
for directory in "$campaign"/csmith-* "$campaign"/yarpgen-*; do
    [ -f "$directory/result.json" ] || continue
    status=$(grep -o '"status":"[a-z_]*"' "$directory/result.json" | head -1 | cut -d'"' -f4)
    signature=$(cat "$directory/failure.signature" 2>/dev/null | tr '\t\n' '  ')
    printf '%s\t%s\t%s' "$(basename "$directory")" "$status" "$signature"
    for step in $steps; do
        if [ -f "$directory/$step.json" ]; then
            printf '\t%s' "$(grep -o '"status":"[a-z_-]*","exit_code":[0-9-]*,"signal":[0-9]*' "$directory/$step.json")"
        else
            printf '\t'
        fi
    done
    printf '\n'
done
