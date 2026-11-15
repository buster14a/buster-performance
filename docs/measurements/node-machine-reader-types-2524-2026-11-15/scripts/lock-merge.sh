#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-1b" EXCLUSIVE_TITLE="#2524 T where it sits (#2867) against main's fact words (#2863)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/2867"
exec ~/buster-fast-bench/exclusive.sh "$@"
