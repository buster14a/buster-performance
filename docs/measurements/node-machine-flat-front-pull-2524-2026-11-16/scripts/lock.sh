#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-flat" EXCLUSIVE_TITLE="Issue 2850 and related: #2524's front by passes (the hand-off's 0004) on today's main" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2524#issuecomment-6931982458"
exec ~/buster-fast-bench/exclusive.sh "$@"
