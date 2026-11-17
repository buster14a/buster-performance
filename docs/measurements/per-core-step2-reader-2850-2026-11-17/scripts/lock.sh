#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2850-facts" EXCLUSIVE_TITLE="Issue 2850 and related: the fact words' kernel at reader time (#2850 step 2)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2850#issuecomment-6933299446"
exec ~/buster-fast-bench/exclusive.sh "$@"
