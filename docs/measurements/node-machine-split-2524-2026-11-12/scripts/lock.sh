#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-split" EXCLUSIVE_TITLE="#2524: split the node machine into T, C and X files" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxnfAH69KLuUes3unhJB"
exec ~/buster-fast-bench/exclusive.sh "$@"
