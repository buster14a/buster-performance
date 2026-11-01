#!/usr/bin/env bash
# Arrays of 16 bytes or more aligned to 16 (buster #978) on the 9700X: the head's build, then the measurement against
# main's build of the floating classifications' record (b651971a), each in a hold of the lock of its own.
set -uo pipefail
cd "$HOME/buster-fast-bench/align-978-claude" || exit 1
echo $$ > queue.pid
lock()
{
    EXCLUSIVE_OWNER=claude-align-978 EXCLUSIVE_TITLE="#978 large arrays aligned to 16: main against head" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/978 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
lock ./build-tree.sh head > build-head.log 2> build-head.stderr
lock ./measure.sh main head > measure.log 2> measure.stderr
echo done > queue.done
