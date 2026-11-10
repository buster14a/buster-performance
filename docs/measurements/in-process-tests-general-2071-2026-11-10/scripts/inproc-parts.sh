#!/bin/bash
# The differential run of the named parts of test-checker-driver (plain build of this session's worktree), each bounded.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
tree=/home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500
cd "$tree" || exit 2
compiler=$(./build.sh print-output --config Release)
for part in "$@"; do
    timeout 1200 env -u CPATH "$compiler" test-checker-driver --executable "$compiler" --part "$part/16" --in-process \
        --clang-server "$tree/build/clang-server/clang-server" --differential > "$D/inproc2/diff-$part.log" 2>&1 &
done
wait
for part in "$@"; do
    echo "part $part | $(grep 'run modes:' "$D/inproc2/diff-$part.log" | tail -1 | cut -c1-200) | $(grep -E 'test-checker:' "$D/inproc2/diff-$part.log" | cut -c1-80 | tr '\n' ';') $(tail -1 "$D/inproc2/diff-$part.log")"
done
