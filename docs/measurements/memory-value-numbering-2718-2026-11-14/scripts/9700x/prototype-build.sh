#!/bin/bash
cd ~/buster-fast-bench/2718-claude/buster
export EXCLUSIVE_OWNER=claude-2718 EXCLUSIVE_TITLE="#2718 memory value numbering" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2718
~/buster-fast-bench/exclusive.sh ./build.sh --config Release > ../build.log 2>&1
echo "exit $?" >> ../build.log
