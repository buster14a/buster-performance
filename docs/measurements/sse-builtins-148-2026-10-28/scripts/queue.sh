#!/usr/bin/env bash
# #148's SSE builtins on the 9700X: each tree's build and the measurement, each in a hold of the lock of its own.
set -uo pipefail
cd "$HOME/buster-fast-bench/sse-148-claude" || exit 1
echo $$ > queue.pid
lock()
{
    EXCLUSIVE_OWNER=claude-sse-148 EXCLUSIVE_TITLE="#148 SSE builtins: main against head" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148#issuecomment-6482945766 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
lock ./build-tree.sh base > build-base.log 2> build-base.stderr
lock ./build-tree.sh head > build-head.log 2> build-head.stderr
lock ./measure.sh base head > measure.log 2> measure.stderr
echo done > queue.done
