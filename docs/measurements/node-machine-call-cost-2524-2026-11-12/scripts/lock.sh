#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-callcost" EXCLUSIVE_TITLE="#2524: the node machine's call cost in T" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxngyTHTN56Cxj8pwk5w"
exec ~/buster-fast-bench/exclusive.sh "$@"
