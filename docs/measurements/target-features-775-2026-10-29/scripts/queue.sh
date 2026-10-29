#!/usr/bin/env bash
# #775 on the 9700X: each tree's build and the measurement, each in a hold of the lock of its own.
set -uo pipefail
cd "$HOME/buster-fast-bench/target-features-775-claude" || exit 1
echo $$ > queue.pid
lock()
{
    EXCLUSIVE_OWNER=claude-target-features-775 EXCLUSIVE_TITLE="#775 code generation's check of target features: main against head" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/775#issuecomment-6491343378 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
lock ./build-tree.sh base > build-base.log 2> build-base.stderr
lock ./build-tree.sh head > build-head.log 2> build-head.stderr
lock ./measure.sh base head > measure.log 2> measure.stderr
echo done > queue.done
