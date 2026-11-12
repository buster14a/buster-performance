#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524" EXCLUSIVE_TITLE="#2524: the node machine's census (step 0)" EXCLUSIVE_LINK="https://claude.ai/code/session_01Egbxnfh2Xz6VipGEYGk4tJ"
exec ~/buster-fast-bench/exclusive.sh "$@"
