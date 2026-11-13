#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run (buster#2559's step 5).
export EXCLUSIVE_OWNER="claude-2559-release" EXCLUSIVE_TITLE="#2559 step 5: Release in parts, its 9700X gate" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxndiQaR1xzwfYok9PNf"
exec ~/buster-fast-bench/exclusive.sh timeout 1200 "$@"
