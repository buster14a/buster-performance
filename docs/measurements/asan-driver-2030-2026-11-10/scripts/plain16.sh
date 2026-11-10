#!/bin/bash
# The plain build at this session's worktree's head, then all 16 parts of test-checker-driver by it, CORES at a time,
# each bounded: the line-walk changes must keep every plain check's result.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
cd /home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500 || exit 2
env -u CPATH ./build.sh --jobs "${CORES:-4}" > "$D/build-plain16.log" 2>&1 || { tail -5 "$D/build-plain16.log"; exit 1; }
grep 'units compiled' "$D/build-plain16.log"
cp "$(./build.sh print-output --config Release)" "$D/compiler-plain4"
seq 1 16 | xargs -P "${CORES:-4}" -I{} timeout 600 "$D/driver.sh" "plain16-{}" "$D/compiler-plain4" "{}/16"
grep '^plain16-' "$D/driver.txt" | awk '{ print $1, $3, $4, substr($0, index($0, "|") + 2) }' | sort -V
