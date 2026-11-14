#!/bin/bash
# The functions' lanes, the runtime snapshot and the serial control on main's plain x86-64 build, alone with a grant of
# 4 and beside 3 CPU-bound processes with a grant of 1, in the hosted shape; one hold each.
set -u
cd ~/buster-fast-bench/2658-claude
exe=$HOME/buster-fast-bench/2658-claude/base/build/cmake/x86-64-g0/Release/compiler
hold()
{
    local title=$1
    shift
    EXCLUSIVE_OWNER=claude-2658 EXCLUSIVE_TITLE="CI time per runner: $title" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2658 \
        ~/buster-fast-bench/exclusive.sh timeout -k 10 590 "$@"
}
i=0
while IFS='|' read -r name command; do
    i=$((i + 1))
    read -r -a words <<< "$command"
    hold "plain alone: $name" scripts/run-shared.sh base runs/plain-$i-alone "$exe" 4,12,5,13 4 0 "$exe" "${words[@]}" 2> runs-plain-$i-alone.stderr
    hold "plain shared: $name" scripts/run-shared.sh base runs/plain-$i-shared "$exe" 4,12,5,13 1 3 "$exe" "${words[@]}" 2> runs-plain-$i-shared.stderr
done <<'LIST'
lanes|test-check-lanes
snapshot|test-snapshot
control|test-lexer --fuzz 100000
LIST
