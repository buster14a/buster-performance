#!/bin/bash
# Prints, for each hosted test job's log in a run's log archive (its directory, unzipped), one tab-separated line per
# converted command the job ran: the run, the job, its runner's CPU model and the parallel runner's report of the
# command ("passed in WALL s, CPU s of CPU"). The converted commands are the preprocessor's four parts and the parser's
# snippets.
# Usage: hosted-times.sh RUN_ID DIRECTORY
set -euo pipefail
run=$1
directory=$2
for log in "$directory"/[0-9]*_Tests*.txt; do
    job=$(basename "$log" .txt)
    job=${job#*_}
    cpu=$(grep -m1 -P 'Z model name\t' "$log" | sed 's/.*: //' || true)
    lines=$(grep -E "##\[group\]Test the (preprocessor's cases|parser's snippets) against clang" "$log" | sed 's/^[^ ]* ##\[group\]//' || true)
    if [ -n "$lines" ]; then
        while IFS= read -r line; do
            printf '%s\t%s\t%s\t%s\n' "$run" "$job" "$cpu" "$line"
        done <<< "$lines"
    fi
done
