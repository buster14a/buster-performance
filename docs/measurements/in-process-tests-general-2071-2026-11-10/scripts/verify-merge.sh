#!/bin/bash
# The plain build of the merged branch, then part 4 of 16 (the huge-pages and time-stages checks) differential, bounded.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
tree=/home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500
cd "$tree" || exit 2
# The call-graph check, queued before this, builds in the same tree: wait for it rather than build beside it.
while cores status | grep -q '"Issue 2071: check-call-graph"'; do sleep 5; done
env -u CPATH ./build.sh --jobs "${CORES:-4}" > "$D/build-merge.log" 2>&1 || { grep -E 'error|FAILED' "$D/build-merge.log" | head -10; exit 1; }
grep 'units compiled' "$D/build-merge.log"
compiler=$(./build.sh print-output --config Release)
timeout 1200 env -u CPATH "$compiler" test-checker-driver --executable "$compiler" --part 4/16 --in-process --clang-server "$tree/build/clang-server/clang-server" \
    --differential > "$D/verify-part4.log" 2>&1
echo "part 4 rc=$? | $(grep -o '[0-9]* runs in this process.*differences' "$D/verify-part4.log") | $(grep -E 'huge pages|test-checker:' "$D/verify-part4.log" | head -4 | tr '\n' ';') $(tail -1 "$D/verify-part4.log")"
