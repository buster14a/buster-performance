#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run.
export EXCLUSIVE_OWNER="claude-2040-stage1" EXCLUSIVE_TITLE="#2040: the design of a much faster stage 1 build" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxnfipgHWGHkS9cGjqJw"
exec ~/buster-fast-bench/exclusive.sh "$@"
