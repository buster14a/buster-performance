#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-step1" EXCLUSIVE_TITLE="#2524 step 1: the node machine in shadow" EXCLUSIVE_LINK="https://claude.ai/code/session_01Egbxnd5GuyW1Lgqacg2kE5"
exec ~/buster-fast-bench/exclusive.sh "$@"
