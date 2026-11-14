#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run (buster#2559's step 5).
export EXCLUSIVE_OWNER="claude-2559-step5b" EXCLUSIVE_TITLE="Issue 2559: Release in parts, renewed step 5 gate" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2559"
exec ~/buster-fast-bench/exclusive.sh timeout 1200 "$@"
