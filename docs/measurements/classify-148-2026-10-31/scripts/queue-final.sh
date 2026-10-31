#!/usr/bin/env bash
# The floating classifications (buster #148) on the 9700X, the final head (the catalog's rows moved last) against the new
# main, whose build the merged run made: the head's build and the measurement, each in a hold of the lock of its own.
set -uo pipefail
cd "$HOME/buster-fast-bench/classify-148-claude" || exit 1
echo $$ > queue-final.pid
lock()
{
    EXCLUSIVE_OWNER=claude-classify-148 EXCLUSIVE_TITLE="#148 classifications: main against the final head" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/973 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
mkdir -p merged-logs
mv measure.log measure-sqlite.log measure-stb.log build-main2.log build-merged.log merged-logs/ 2>/dev/null
lock ./build-tree.sh final > build-final.log 2> build-final.stderr
lock ./measure.sh main2 final > measure.log 2> measure.stderr
echo done > queue-final.done
