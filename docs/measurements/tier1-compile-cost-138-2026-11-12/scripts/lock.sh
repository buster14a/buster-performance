#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-tier1-cost" EXCLUSIVE_TITLE="#138: what Tier 1's pipeline costs a compile, by stage" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxngAjeoMm4jcWs4hjWw"
exec ~/buster-fast-bench/exclusive.sh "$@"
