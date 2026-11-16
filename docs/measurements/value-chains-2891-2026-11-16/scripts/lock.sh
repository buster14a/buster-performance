#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2891" EXCLUSIVE_TITLE="#2891: an && or || value's first operand lowered as branches" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2891#issuecomment-6928753176"
exec ~/buster-fast-bench/exclusive.sh "$@"
