#!/usr/bin/env bash
# The bit builtins (buster #148) on the 9700X, the final head: its build and the measurement against main, each in a
# hold of the lock of its own.
set -uo pipefail
cd "$HOME/buster-fast-bench/bits-builtins-148-claude" || exit 1
echo $$ > queue-final.pid
lock()
{
    EXCLUSIVE_OWNER=claude-bits-builtins-148 EXCLUSIVE_TITLE="#148 bit builtins: main against the final head" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
mkdir -p first
mv measure.log measure-sqlite.log measure-stb.log build-head.log first/ 2>/dev/null
lock ./build-tree.sh final > build-final.log 2> build-final.stderr
lock ./measure.sh main final > measure.log 2> measure.stderr
echo done > queue-final.done
