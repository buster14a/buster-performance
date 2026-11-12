#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-fold" EXCLUSIVE_TITLE="#2524: X's one state test after a record's row" EXCLUSIVE_LINK="https://claude.ai/code/session_01Egbxndgx1o2bM83oFZJ8gt"
exec ~/buster-fast-bench/exclusive.sh "$@"
