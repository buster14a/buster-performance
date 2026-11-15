#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-layout" EXCLUSIVE_TITLE="#2524: the node machine's sweeps' code layout" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2524#issuecomment-6892645170"
exec ~/buster-fast-bench/exclusive.sh "$@"
