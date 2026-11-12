#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-672-rest" EXCLUSIVE_TITLE="#672: the one-core lever #2524 leaves (file scope, fixed costs, front end, emission)" EXCLUSIVE_LINK="https://claude.ai/code/session_01Egbxneby9DmbYXvcARm3Wp"
exec ~/buster-fast-bench/exclusive.sh "$@"
