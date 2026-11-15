#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2850-step1" EXCLUSIVE_TITLE="#2850 step 1: the fact words in the shadow" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2850#issuecomment-6898614035"
exec ~/buster-fast-bench/exclusive.sh "$@"
