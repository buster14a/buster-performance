#!/usr/bin/env bash
# The alignment builtins (buster #148) on the 9700X: the measurement of the builtins' head against its base, #984's merged
# head, whose builds the branch's test rounds made (BUSTER_DEBUG_INFO=0, as build-tree.sh builds), in a hold of the lock.
set -uo pipefail
cd "$HOME/buster-fast-bench/align-148-claude" || exit 1
echo $$ > queue.pid
lock()
{
    EXCLUSIVE_OWNER=claude-align-148 EXCLUSIVE_TITLE="#148 alignment builtins: base against head" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
for tree in base head; do
    echo "tree $tree commit $(cat $tree/COMMIT)"
    tail -2 $tree/build.log
    sha256sum $tree/build/compiler
done > builds.log
lock ./measure.sh base head > measure.log 2> measure.stderr
echo done > queue.done
