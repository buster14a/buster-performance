#!/usr/bin/env bash
# #759 after merging main, on the 9700X: each tree's build and the measurement, each in a hold of the lock of its own.
set -uo pipefail
cd "$HOME/buster-fast-bench/merged-759-780-claude" || exit 1
echo $$ > queue-759.pid
lock()
{
    EXCLUSIVE_OWNER=claude-sse-148 EXCLUSIVE_TITLE="#759 SSE builtins after merging main: merge-base against head" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/759 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
lock ./build-tree.sh m759 > build-m759.log 2> build-m759.stderr
lock ./build-tree.sh h759 > build-h759.log 2> build-h759.stderr
lock ./measure.sh m759 h759 > measure-759.log 2> measure-759.stderr
echo done > queue-759.done
