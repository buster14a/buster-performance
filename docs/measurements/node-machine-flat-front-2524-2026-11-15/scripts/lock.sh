#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-1b" EXCLUSIVE_TITLE="#2524: the front's walk, a front without a stack" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2524#issuecomment-6901949510"
exec ~/buster-fast-bench/exclusive.sh "$@"
