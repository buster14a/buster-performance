#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2850-reads" EXCLUSIVE_TITLE="#2850 step 2's second piece: a census of what reads T's record, in the shadow; and #2872's two passes" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2850#issuecomment-6911651414"
exec ~/buster-fast-bench/exclusive.sh "$@"
