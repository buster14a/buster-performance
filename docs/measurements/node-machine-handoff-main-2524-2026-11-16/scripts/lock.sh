#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2524-handoff" EXCLUSIVE_TITLE="#2524's hand-off series (C and X, and the tests, at reader time, in the shadow) and #2882, on today's main" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2524#issuecomment-6919991971"
exec ~/buster-fast-bench/exclusive.sh "$@"
