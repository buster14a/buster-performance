#!/usr/bin/env bash
# #780 after merging main, on the 9700X: each tree's build, the -c measurement and benchmark-backend-source, each in a
# hold of the lock of its own.
set -uo pipefail
cd "$HOME/buster-fast-bench/merged-759-780-claude" || exit 1
echo $$ > queue-780.pid
lock()
{
    EXCLUSIVE_OWNER=claude-deep-780 EXCLUSIVE_TITLE="#780 deep values beside the memory classes: main against head" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/780#issuecomment-6488590421 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
lock ./build-tree.sh m780 > build-m780.log 2> build-m780.stderr
lock ./build-tree.sh h780 > build-h780.log 2> build-h780.stderr
lock ./measure.sh m780 h780 > measure-780.log 2> measure-780.stderr
lock ./backend.sh m780 h780 > backend-780.log 2> backend-780.stderr
echo done > queue-780.done
