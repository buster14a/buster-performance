#!/bin/bash
# $1 compiler, $2 label
set -u
out=~/.cache/claude-2758/runs/$2
mkdir -p "$out"
cd /home/user/buster
start=$(date +%s.%N)
perf record -F 199 -e cpu-clock -o "$out/perf.data" -- "$1" test-ssa-source --typed --tier1 build/c-testsuite/tests/single-exec/00040.c > "$out/report.txt" 2>&1
status=$?
end=$(date +%s.%N)
echo "status $status wall $(echo "$end - $start" | bc)" >> "$out/report.txt"
