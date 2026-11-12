#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2555" EXCLUSIVE_TITLE="#2555: #2538's eight-lane baseline rows measured again on the clear host" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2555"
exec ~/buster-fast-bench/exclusive.sh "$@"
