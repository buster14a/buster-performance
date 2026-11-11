#!/bin/bash
# Prints, for each hosted test job's log in a run's log archive (its directory, unzipped), tab-separated lines: the run,
# the job, its runner's CPU model, then either the build step's clang server line ("build") or, for each converted
# command (the preprocessor's four parts, the parser's two commands) and test-checker-driver's commands, the parallel
# runner's report ("passed in WALL s, CPU s of CPU") and the command's clang server or run-mode line.
# Usage: hosted-served.sh RUN_ID DIRECTORY
set -euo pipefail
run=$1
directory=$2
for log in "$directory"/[0-9]*_Tests*.txt; do
    job=$(basename "$log" .txt)
    job=${job#*_}
    cpu=$(grep -m1 -P 'Z model name\t' "$log" | sed 's/.*: //' || true)
    sed -e 's/^[^ ]* //' -e 's/\r$//' "$log" | awk -v run="$run" -v job="$job" -v cpu="$cpu" '
        /^##\[group\]/ { title = substr($0, 10); keep = title ~ /^Test the (preprocessor.s cases|parser.s snippets|semantic driver.s|parser.s snippets)/ || title ~ /narrow-unsigned sign comparisons/ || title ~ /lazy/ }
        /^clang-server: .*smoke request/ { printf "%s\t%s\t%s\tbuild\t%s\n", run, job, cpu, $0 }
        keep && /^test-(preprocessor|parser): clang server \(/ { printf "%s\t%s\t%s\t%s\t%s\n", run, job, cpu, title, $0 }
        keep && /^checker-driver: run modes:/ { printf "%s\t%s\t%s\t%s\t%s\n", run, job, cpu, title, $0 }
    '
done
