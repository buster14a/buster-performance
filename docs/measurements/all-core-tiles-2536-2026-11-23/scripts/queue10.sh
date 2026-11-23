#!/bin/bash
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
cd "$dir"
./run9.sh tiles3 tiles3-pair2 3 'whole|||' 't4096|||--parse-tile=4096' 't16384|||--parse-tile=16384'
echo QUEUE-DONE
