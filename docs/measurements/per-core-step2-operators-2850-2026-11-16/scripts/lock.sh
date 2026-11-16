#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2850-step2" EXCLUSIVE_TITLE="#2850 step 2's first piece: T's other operators on the fact words' records, in the shadow" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2850#issuecomment-6903451811"
exec ~/buster-fast-bench/exclusive.sh "$@"
