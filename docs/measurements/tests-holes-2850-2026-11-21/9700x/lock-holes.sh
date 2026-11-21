#!/bin/bash
# usage: lock-holes.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2850-holes" EXCLUSIVE_TITLE="Problem 2850 solution: the tests' holes and the objects' side (#3201, #3203)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/3201#issuecomment-7058791784"
exec ~/buster-fast-bench/exclusive.sh "$@"
