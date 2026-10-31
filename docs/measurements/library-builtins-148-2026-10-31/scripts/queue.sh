#!/usr/bin/env bash
# The library builtins (buster #148) on the 9700X: each tree's build and the measurement, each in a hold of
# the lock of its own.
set -uo pipefail
cd "$HOME/buster-fast-bench/library-builtins-148-claude" || exit 1
echo $$ > queue.pid
lock()
{
    EXCLUSIVE_OWNER=claude-library-builtins-148 EXCLUSIVE_TITLE="#148 library builtins: main against head" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148#issuecomment-6525264816 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
lock ./build-tree.sh main > build-main.log 2> build-main.stderr
lock ./build-tree.sh head > build-head.log 2> build-head.stderr
lock ./measure.sh main head > measure.log 2> measure.stderr
echo done > queue.done
