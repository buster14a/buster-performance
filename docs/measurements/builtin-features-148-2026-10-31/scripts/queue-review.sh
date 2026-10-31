#!/usr/bin/env bash
# The review's fix of the builtins' target features (buster #148, #775) on the 9700X: the PR's head before it ("merge")
# and after it ("fix"), each tree's build and the measurement each in a hold of the lock of its own, as queue.sh. The
# first measurement's logs move to first-run/ first, as measure.sh appends to measure-UNIT.log.
set -uo pipefail
cd "$HOME/buster-fast-bench/builtin-features-148-claude" || exit 1
echo $$ > queue-review.pid
mkdir -p first-run
mv measure-sqlite.log measure-stb.log measure.log first-run/ 2> /dev/null
lock()
{
    EXCLUSIVE_OWNER=claude-builtin-features-148 EXCLUSIVE_TITLE="#148/#775 builtins' required target features: the review's fix" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/949 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
lock ./build-tree.sh merge > build-merge.log 2> build-merge.stderr
lock ./build-tree.sh fix > build-fix.log 2> build-fix.stderr
lock ./measure.sh merge fix > measure.log 2> measure.stderr
echo done > queue-review.done
