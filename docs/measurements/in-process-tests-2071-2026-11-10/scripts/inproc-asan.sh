#!/bin/bash
# The address build of this session's worktree (#2071's prototype), then the sweep's parts both ways under it.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
cd /home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500 || exit 2
env -u CPATH BUSTER_SANITIZER=address ./build.sh --jobs "${CORES:-6}" > "$D/build-2071-asan.log" 2>&1 || { tail -15 "$D/build-2071-asan.log"; exit 1; }
grep 'units compiled' "$D/build-2071-asan.log"
cp "$(BUSTER_SANITIZER=address ./build.sh print-output --config Release)" "$D/compiler-2071-asan"
CORES_CPUS=${CORES_CPUS:-2,10,3,11} "$D/inproc-time.sh" asan "$D/compiler-2071-asan" nothp
