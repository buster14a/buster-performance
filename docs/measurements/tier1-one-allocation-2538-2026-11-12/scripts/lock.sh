#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2538" EXCLUSIVE_TITLE="#2538: Tier 1 allocates each function once" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxndbJC23N78MH1MRRja"
exec ~/buster-fast-bench/exclusive.sh "$@"
