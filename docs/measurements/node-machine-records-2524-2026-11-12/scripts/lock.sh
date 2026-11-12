#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-records" EXCLUSIVE_TITLE="#2524 step 1: the node machine's records as columns" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxnhBFSaherBMtxcUzcF"
exec ~/buster-fast-bench/exclusive.sh "$@"
