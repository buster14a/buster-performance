#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-1b" EXCLUSIVE_TITLE="#2524: C and X where they sit, at reader time" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2524#issuecomment-6904114428"
exec ~/buster-fast-bench/exclusive.sh "$@"
