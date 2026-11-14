#!/bin/bash
# Each eight-CPU heading's command on main's x86-64 MSan build, in the hosted shape: alone with the grant of 4, as the
# runner runs it, then beside 3 CPU-bound processes with a grant of 1. One hold of the host lock per run.
set -u
cd ~/buster-fast-bench/2658-claude
exe=$HOME/buster-fast-bench/2658-claude/base/build/cmake/x86-64-memory-O3/Release/compiler
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
    hold "8-CPU heading alone: $name" scripts/run-shared.sh base runs/shared-$i-alone "$exe" 4,12,5,13 4 0 "$exe" "${words[@]}" 2> runs-shared-$i-alone.stderr
    hold "8-CPU heading shared: $name" scripts/run-shared.sh base runs/shared-$i-shared "$exe" 4,12,5,13 1 3 "$exe" "${words[@]}" 2> runs-shared-$i-shared.stderr
done <<'LIST'
lanes|test-check-lanes
snapshot|test-snapshot
foreign|test-foreign --cross-check
files|test-files
units|test-check-units
executable|test-executable
lanes-runtime|test-lanes
link|test-link
static|test-static --cross-check
calling|test-calling-convention --cross-check
LIST
