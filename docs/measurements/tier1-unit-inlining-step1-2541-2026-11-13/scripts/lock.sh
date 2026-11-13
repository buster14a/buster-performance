#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2541-step1" EXCLUSIVE_TITLE="#2541 step 1: small internal callees from unit summaries, its 9700X gate" EXCLUSIVE_LINK="https://claude.ai/code/session_01Egbxnep5QxhQX6iueW9guL"
exec ~/buster-fast-bench/exclusive.sh "$@"
