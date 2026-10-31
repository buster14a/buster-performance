#!/usr/bin/env bash
# The floating classifications (buster #148) on the 9700X, after merging main into the branch: the new main's build, the
# merge's, and the measurement of one against the other, each in a hold of the lock of its own.
set -uo pipefail
cd "$HOME/buster-fast-bench/classify-148-claude" || exit 1
echo $$ > queue-merged.pid
lock()
{
    EXCLUSIVE_OWNER=claude-classify-148 EXCLUSIVE_TITLE="#148 classifications: main against the merge" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/973 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
mkdir -p first-logs
mv measure.log measure-sqlite.log measure-stb.log build-main.log build-head.log first-logs/ 2>/dev/null
lock ./build-tree.sh main2 > build-main2.log 2> build-main2.stderr
lock ./build-tree.sh merged > build-merged.log 2> build-merged.stderr
lock ./measure.sh main2 merged > measure.log 2> measure.stderr
echo done > queue-merged.done
