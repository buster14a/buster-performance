#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-baked" EXCLUSIVE_TITLE="#2524 step 1: baked C and X tables" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxnfvRRsXKNNJn8SaczC"
exec ~/buster-fast-bench/exclusive.sh "$@"
