#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-672-st" EXCLUSIVE_TITLE="#672: the one-core design (single-threaded throughput)" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxndygqguGAYmkE91KfZ"
exec ~/buster-fast-bench/exclusive.sh "$@"
