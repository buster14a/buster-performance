#!/bin/bash
# tally.sh DIR...: one line per generated program of #142's campaign chunks:
# chunk, program, result status and signature, then each step's status
# (buster-tier0/1 and clang-o0/o2 compile and run) where the step ran.
for top in "$@"; do
    for result in "$top"/chunk-*/campaign-*/*/result.json; do
        dir=$(dirname "$result")
        program=$(basename "$dir")
        chunk=$(basename "$(dirname "$(dirname "$dir")")")
        status=$(sed -n 's/.*"status":"\([^"]*\)".*/\1/p' "$result")
        signature=$(sed -n 's/.*"signature":"\([^"]*\)".*/\1/p' "$result")
        steps=""
        for step in buster-tier0-compile buster-tier0-run buster-tier1-compile buster-tier1-run clang-o0-compile clang-o0-run clang-o2-compile clang-o2-run; do
            if [ -f "$dir/$step.json" ]; then
                s=$(sed -n 's/.*"status":"\([^"]*\)","exit_code":\([0-9-]*\).*/\1:\2/p' "$dir/$step.json")
                steps="$steps $step=$s"
            fi
        done
        echo "$chunk $program $status sig=${signature:-none}$steps"
    done
done
