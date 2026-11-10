#!/bin/bash
# Builds the branch's address row (fixed address, baked) in this session's worktree and keeps its executable.
set -u
export LC_ALL=C
out=$HOME/.cache/claude-pr2056-review/2030
cd /home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500 || exit 2
TIMEFORMAT='%R %U %S'
{ time env -u CPATH BUSTER_SANITIZER=address ./build.sh --jobs "${CORES:-6}" > "$out/build-fixed.log" 2>&1; } 2> "$out/build-fixed.time"
echo "fixed rc=$? $(cat "$out/build-fixed.time") | $(grep 'units compiled' "$out/build-fixed.log")" >> "$out/variants.txt"
cp "$(BUSTER_SANITIZER=address ./build.sh print-output --config Release)" "$out/compiler-fixed"
