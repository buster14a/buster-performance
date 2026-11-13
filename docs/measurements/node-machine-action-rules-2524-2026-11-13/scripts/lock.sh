#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-tcost" EXCLUSIVE_TITLE="#2524: the node machine's T cost (action rules)" EXCLUSIVE_LINK="https://claude.ai/code/session_01Egbxnde77ZD2pNkjaLtpoD"
exec ~/buster-fast-bench/exclusive.sh "$@"
