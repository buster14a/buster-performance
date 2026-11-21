#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2850-sides" EXCLUSIVE_TITLE="Problem 2850 solution: a summary node's side facts on the window (#2850)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2850#issuecomment-7053609091"
exec ~/buster-fast-bench/exclusive.sh "$@"
