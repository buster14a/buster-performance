#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-cx" EXCLUSIVE_TITLE="#2524: the node machine C and X dispatch" EXCLUSIVE_LINK="https://claude.ai/code/session_01NNmNQtUTU2NzKNtCgdUaJP"
exec ~/buster-fast-bench/exclusive.sh "$@"
