#!/usr/bin/env bash
# #148's measurement queue: the head's build, then the measurement, each in a hold of its own.
cd "$HOME/buster-fast-bench/alloca-frame-148-claude" || exit 1
echo $$ > queue.pid
export EXCLUSIVE_OWNER=claude-148-alloca EXCLUSIVE_TITLE="#148 alloca and frame builtins (claude)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
~/buster-fast-bench/exclusive.sh ./build-tree.sh head > build-head.log 2>&1
~/buster-fast-bench/exclusive.sh ./measure.sh > measure.log 2>&1
echo queue-done >> measure.log
