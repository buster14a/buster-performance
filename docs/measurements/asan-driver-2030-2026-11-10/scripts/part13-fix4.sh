#!/bin/bash
# Rebuilds this session's worktree's address compiler with every line-walk fix, then times part 13 by it (bounded).
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
first=$(echo "${CORES_CPUS:-2}" | cut -d, -f1)
cd /home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500 || exit 2
env -u CPATH BUSTER_SANITIZER=address ./build.sh --jobs "${CORES:-2}" > "$D/build-fix4-asan.log" 2>&1 || exit 1
grep 'units compiled' "$D/build-fix4-asan.log"
cp "$(BUSTER_SANITIZER=address ./build.sh print-output --config Release)" "$D/compiler-fixed4"
timeout 1200 taskset -c "$first" "$D/driver.sh" p13-fixed4 "$D/compiler-fixed4" 13/16 "" "" nothp
grep -E '^p13-fixed4' "$D/driver.txt" | cut -c1-110
