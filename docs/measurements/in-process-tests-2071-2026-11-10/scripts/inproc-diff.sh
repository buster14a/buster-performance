#!/bin/bash
# #2071's equivalence check: all 16 parts of test-checker-driver by this session's worktree's plain build with
# --in-process --clang-server --differential, CORES at a time, each bounded; then each part's run-modes line.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
tree=/home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500
cd "$tree" || exit 2
compiler=$(./build.sh print-output --config Release)
server=$tree/build/clang-server/clang-server
mkdir -p "$D/inproc"
run_part()
{
    local part=$1
    timeout 1200 env -u CPATH "$compiler" test-checker-driver --executable "$compiler" --part "$part/16" --in-process \
        --clang-server "$server" --differential > "$D/inproc/diff-$part.log" 2>&1
    echo "part $part rc=$? | $(grep 'run modes:' "$D/inproc/diff-$part.log" | tail -1 | cut -c1-220) | $(tail -1 "$D/inproc/diff-$part.log")"
}
export -f run_part
export D tree compiler server
seq 1 16 | xargs -P "${CORES:-4}" -I{} bash -c 'run_part {}' | sort -V
