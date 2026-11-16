#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2883" EXCLUSIVE_TITLE="#2883: a condition's && and || lowered as branches" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2883#issuecomment-6922262960"
exec ~/buster-fast-bench/exclusive.sh "$@"
