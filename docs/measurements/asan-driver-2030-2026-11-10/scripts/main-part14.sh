#!/bin/bash
# Plain build of main at 3bfa0af18 (the PR's base) in a worktree of its own, then part 14 of 16 by it from that tree:
# whether the asm-placed failures are main's on this laptop or the PR's.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
tree=$D/wt/main-3bfa0af18
[ -d "$tree" ] || git -C /home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500 worktree add -q --detach "$tree" 3bfa0af18 || exit 2
cd "$tree" || exit 2
env -u CPATH ./build.sh --jobs "${CORES:-4}" > "$D/build-main-3bfa.log" 2>&1 || { tail -5 "$D/build-main-3bfa.log"; exit 1; }
cp "$(./build.sh print-output --config Release)" "$D/compiler-plain-main3bfa"
DRIVER_TREE=$tree timeout 600 "$D/driver.sh" main3bfa-14 "$D/compiler-plain-main3bfa" 14/16
grep '^main3bfa-14' "$D/driver.txt" | cut -c1-110
grep -h 'test-checker:' "$D/driver-main3bfa-14.log" | cut -c1-160
