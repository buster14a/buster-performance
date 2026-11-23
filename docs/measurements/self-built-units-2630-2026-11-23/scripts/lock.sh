#!/bin/bash
# usage: lock.sh COMMAND... ; COMMAND under the 9700X lock, held for that one run, with a 30-minute limit.
export EXCLUSIVE_OWNER="claude-2630" EXCLUSIVE_TITLE="#2630: Develop's units by the previous stage (BUSTER_SELF_BUILT)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2630"
exec ~/buster-fast-bench/exclusive.sh timeout 1800 "$@"
