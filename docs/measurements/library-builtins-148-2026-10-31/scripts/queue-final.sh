#!/usr/bin/env bash
# The library builtins (buster #148) on the 9700X, the final head: its tree's build and the measurement against main's,
# each in a hold of the lock of its own, as queue.sh. Main's tree is queue.sh's, built already. The first measurement's
# logs move to first-run/ first, as measure.sh appends to measure-UNIT.log.
set -uo pipefail
cd "$HOME/buster-fast-bench/library-builtins-148-claude" || exit 1
echo $$ > queue-final.pid
mkdir -p first-run
mv measure-sqlite.log measure-stb.log measure.log build-head.log first-run/ 2> /dev/null
lock()
{
    EXCLUSIVE_OWNER=claude-library-builtins-148 EXCLUSIVE_TITLE="#148 library builtins: main against the final head" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148#issuecomment-6525264816 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
lock ./build-tree.sh head > build-head.log 2> build-head.stderr
lock ./measure.sh main head > measure.log 2> measure.stderr
echo done > queue-final.done
