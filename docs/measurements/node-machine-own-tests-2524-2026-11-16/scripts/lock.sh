#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-1b" EXCLUSIVE_TITLE="#2524: the tests in the machine's own form" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2524#issuecomment-6909545335"
exec ~/buster-fast-bench/exclusive.sh "$@"
