#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2850-tests" EXCLUSIVE_TITLE="Issue 2850 and related: the tests on the window (#2850)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2850#issuecomment-6951406678"
exec ~/buster-fast-bench/exclusive.sh "$@"
