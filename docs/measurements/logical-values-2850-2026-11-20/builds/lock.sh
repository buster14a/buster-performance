#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2850-values" EXCLUSIVE_TITLE="Problem 2850 solution: an operator's value and a comma on the window (#2850)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2850#issuecomment-7049301495"
exec ~/buster-fast-bench/exclusive.sh "$@"
