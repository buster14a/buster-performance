#!/usr/bin/env bash
# #148's second measurement queue: the final head's build (head2), then the measurement against base, each in a hold.
cd "$HOME/buster-fast-bench/alloca-frame-148-claude" || exit 1
echo $$ > queue2.pid
export EXCLUSIVE_OWNER=claude-148-alloca EXCLUSIVE_TITLE="#148 alloca and frame builtins (claude)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
~/buster-fast-bench/exclusive.sh ./build-tree.sh head2 > build-head2.log 2>&1
~/buster-fast-bench/exclusive.sh ./measure.sh base head2 > measure2.log 2>&1
echo queue-done >> measure2.log
