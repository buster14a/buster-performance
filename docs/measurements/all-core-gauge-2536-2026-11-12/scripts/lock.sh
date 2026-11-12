#!/bin/bash
# lock.sh COMMAND...: one run under the 9700X's lock, held for that run alone.
export EXCLUSIVE_OWNER="claude-2536-gauge" EXCLUSIVE_TITLE="All-core path step 0: the gauge (#2536)" EXCLUSIVE_LINK="https://claude.ai/code/session_01Egbxngsqw4aTD4bHyMzajF"
exec ~/buster-fast-bench/exclusive.sh "$@"
