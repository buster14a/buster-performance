#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-tier1-quality" EXCLUSIVE_TITLE="#138: Tier 1's code against clang -O2, the gap by cause" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxngevoFqu5FedvEPmV8"
exec ~/buster-fast-bench/exclusive.sh "$@"
