#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2541-step2" EXCLUSIVE_TITLE="#2541 step 2: external, single-site and dead functions, limits by sweep" EXCLUSIVE_LINK="https://claude.ai/code/session_01NNmNQw2aKbpidzpievZNnj"
exec ~/buster-fast-bench/exclusive.sh "$@"
