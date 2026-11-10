#!/bin/bash
# The address row's build of this session's worktree (#2068's change), kept as compiler-2068, with each object's
# remaining large .bss for the decision on tier1_select_burs.c's tables.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
cd /home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500 || exit 2
env -u CPATH BUSTER_SANITIZER=address ./build.sh --jobs "${CORES:-6}" > "$D/build-2068.log" 2>&1 || { tail -15 "$D/build-2068.log"; exit 1; }
grep 'units compiled' "$D/build-2068.log"
cp "$(BUSTER_SANITIZER=address ./build.sh print-output --config Release)" "$D/compiler-2068"
