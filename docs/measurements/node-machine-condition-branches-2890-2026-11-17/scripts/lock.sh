#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2890" EXCLUSIVE_TITLE="Issue 2850 and related: #2890, the node machine writes a condition's branches" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2890#issuecomment-6931984431"
exec ~/buster-fast-bench/exclusive.sh "$@"
