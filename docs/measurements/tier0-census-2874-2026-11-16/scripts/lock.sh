#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2874" EXCLUSIVE_TITLE="#2874: a census of Tier 0's 153 instructions a typed entry (the one-core path's step 4)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2874#issuecomment-6914011546"
exec ~/buster-fast-bench/exclusive.sh "$@"
