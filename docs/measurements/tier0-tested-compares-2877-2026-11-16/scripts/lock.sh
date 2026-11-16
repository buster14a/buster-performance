#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2877" EXCLUSIVE_TITLE="#2877: Tier 0 makes a compare's value and tests it again before a branch" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2877#issuecomment-6918317922"
exec ~/buster-fast-bench/exclusive.sh "$@"
