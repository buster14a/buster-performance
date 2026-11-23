#!/bin/bash
cd ~/buster-fast-bench/2826-claude
export EXCLUSIVE_OWNER=claude-2826 EXCLUSIVE_TITLE="buster #2826: value numbering with memory policy" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2826
~/buster-fast-bench/exclusive.sh timeout -k 5 1500 bash run.sh main compile > main-compile.log 2>&1
~/buster-fast-bench/exclusive.sh timeout -k 5 1500 bash run.sh br compile > br-compile.log 2>&1
echo done > chain3.done
