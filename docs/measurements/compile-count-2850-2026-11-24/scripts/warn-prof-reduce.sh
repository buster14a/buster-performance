#!/bin/bash
# After the hold: each profile by symbol, then the perf data removed.
set -u
out=$(ls -d ~/buster-fast-bench/2850-claude-vjgaob/results/warn-prof-* | tail -1)
cd "$out" || exit 1
test -f held || exit 1
for f in perf-*.data; do perf report -i "$f" --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' > "report-${f#perf-}.txt"; done
rm -f perf-*.data
echo done > complete
