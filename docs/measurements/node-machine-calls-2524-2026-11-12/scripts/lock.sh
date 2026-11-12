#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-calls" EXCLUSIVE_TITLE="#2524: calls as a code of the node machine" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxneksBJDmw73CqxW91j"
exec ~/buster-fast-bench/exclusive.sh "$@"
