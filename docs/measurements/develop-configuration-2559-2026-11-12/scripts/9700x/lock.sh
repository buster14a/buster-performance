#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run (buster#2559's gates).
export EXCLUSIVE_OWNER="claude-2559-develop" EXCLUSIVE_TITLE="#2559: the Develop configuration's gates" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxndWWhwR7GBdSUAKSEn"
exec ~/buster-fast-bench/exclusive.sh timeout 1200 "$@"
