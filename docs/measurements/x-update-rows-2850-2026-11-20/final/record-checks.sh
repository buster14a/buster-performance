#!/bin/bash
# record-checks.sh CHECKS OUT: what the record keeps of checks-rows.sh's run in CHECKS: the script, its progress and
# revision, each part's status, the shadows' counts' lines, the ownership check's output and the complete driver's
# lists' items.
checks=$1; out=$2
mkdir -p "$out" || exit 1
cp /home/user/keep/xrows/checks-rows.sh "$checks/progress.txt" "$checks/revision.txt" "$checks/ownership.txt" "$out/" || exit 1
cp "$checks/shadow/status.txt" "$out/shadow-status.txt" && cp "$checks/test-checker/status.txt" "$out/test-checker-status.txt" && cp "$checks/modes/status.txt" "$out/modes-status.txt" || exit 1
for f in "$checks"/shadow/*window-rows*.out; do echo "== $(basename "$f")"; grep -a '^node-shadow: window contexts expressions=\|^node-shadow: window rows expressions=\|^node-shadow: window rows listed\|^node-shadow: window rows records read' "$f"; done > "$out/rows-counts.txt"
for list in light heavy; do grep -a '^parallel:\|^== ' "$checks/complete-$list.log" > "$out/complete-$list-items.txt"; done
ls "$out"
