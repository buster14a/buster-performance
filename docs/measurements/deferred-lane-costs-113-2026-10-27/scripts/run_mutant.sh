#!/bin/bash
# Builds mutant NAME of the worktree at -O1 in its own directory and runs the suites it names, each of which must fail:
# writes NAME.result with each suite's exit status and failure line.
W=/home/david/dev/ai/claude/buster/.claude/worktrees/salter-fragments-106-107-21a90f
M=/home/david/.cache/claude-113-lanes/mutants
name="$1"
dir="$M/$name"
suites=$(python3 "$M/make_mutant.py" "$W" "$name" "$dir") || { echo "$name: replacement failed" > "$M/$name.result"; exit 1; }
cd "$dir" || exit 1
export TMPDIR=/home/david/.cache/claude-113-lanes/tmp
unset CPATH C_INCLUDE_PATH
if ! BUSTER_DEBUG_INFO=0 ./build.sh > build.txt 2>&1; then
    echo "$name: build failed" > "$M/$name.result"
    exit 1
fi
: > "$M/$name.result"
for suite in $suites; do
    if [ "$suite" = lanes ]; then
        timeout 300 ./build/compiler test-lanes > lanes.txt 2>&1
        status=$?
        line=$(grep -E "wrong|failed" lanes.txt | grep -v " 0 wrong\| 0 failed" | head -2 | tr '\n' ' ')
    else
        timeout 600 ./build/compiler test-checker-deferred > deferred.txt 2>&1
        status=$?
        line=$(tail -1 deferred.txt)
    fi
    echo "$name $suite exit=$status $line" >> "$M/$name.result"
done
