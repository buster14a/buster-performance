#!/bin/bash
# A serial control for queue-shared.sh: the C lexer test (one thread) alone with a grant of 4 and beside 3 CPU-bound
# processes, on main's x86-64 MSan build in the hosted shape; one hold each.
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
hold "serial control alone: test-lexer" scripts/run-shared.sh base runs/control-lexer-alone "$exe" 4,12,5,13 4 0 "$exe" test-lexer --fuzz 20000 2> runs-control-lexer-alone.stderr
hold "serial control shared: test-lexer" scripts/run-shared.sh base runs/control-lexer-shared "$exe" 4,12,5,13 1 3 "$exe" test-lexer --fuzz 20000 2> runs-control-lexer-shared.stderr
