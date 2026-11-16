#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-1b" EXCLUSIVE_TITLE="#2867: T where it sits, against main's fact words after #2868" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/2867"
exec ~/buster-fast-bench/exclusive.sh "$@"
