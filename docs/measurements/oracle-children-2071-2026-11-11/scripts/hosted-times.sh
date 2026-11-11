#!/bin/bash
# Copied from ../../served-oracles-remaining-2071-2026-11-11/scripts/hosted-times.sh (buster-performance#386); only this line is new.
# Prints, for each hosted test shard's log in a run's log archive (its directory, unzipped), one tab-separated line per
# command of interest: the run, the row (host architecture), the shard, the runner's CPU model, the command (the
# inventory's group title), the parallel runner's wall and CPU seconds, and the command's clang server line, if any.
# The commands are test-preprocessor's (the cases' four parts, the repository's units) and test-parser's snippets,
# which this change leaves as they were: a control for the runner's speed.
# Usage: hosted-times.sh RUN_ID DIRECTORY
set -euo pipefail
run=$1
directory=$2
for log in "$directory"/[0-9]*_Tests*"shard "[1-4]" of 4"*.txt; do
    row=$(basename "$log" | sed -E 's/.*Clang 23, ([^,]*), .*/\1/')
    shard=$(basename "$log" | sed -E 's/.*shard ([0-9]) of 4.*/\1/')
    cpu=$(grep -m1 -P 'Z model name\t' "$log" | sed 's/.*: //' || true)
    sed -e 's/^[^ ]* //' -e 's/\r$//' "$log" | awk -v run="$run" -v row="$row" -v shard="$shard" -v cpu="$cpu" '
        function flush() { if (title != "") { printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", run, row, shard, cpu, title, wall, seconds, served } title = "" }
        /^##\[group\]Test the (preprocessor.s cases against clang|preprocessor on the repository.s translation units|parser.s snippets against clang)/ {
            flush()
            line = substr($0, 10)
            title = line; sub(/: (passed|FAILED|failed).*/, "", title)
            wall = line; sub(/.* in /, "", wall); sub(/ s,.*/, "", wall)
            seconds = line; sub(/.*, /, "", seconds); sub(/ s of CPU.*/, "", seconds)
            served = ""
            next
        }
        /^##\[endgroup\]/ { flush() }
        title != "" && /^test-(preprocessor|parser): clang server \(/ { served = served (served != "" ? " | " : "") $0 }
        END { flush() }
    '
done
