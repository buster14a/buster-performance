#!/bin/bash
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
cd "$dir"
until grep -q "QUEUE-DONE\|setup failed" queue6.log; do sleep 10; done
./run7.sh medium pages-sizes 2 'plain|||' 'm64|64|BUSTER_HUGE_PAGES=medium|' 'm32|32|BUSTER_HUGE_PAGES=medium|' 'm16|16|BUSTER_HUGE_PAGES=medium|' 'm128|128|BUSTER_HUGE_PAGES=medium|' 'm16to64|16,32,64|BUSTER_HUGE_PAGES=medium|'
./setup2.sh b7d0b5ed tiles3 tiles3.patch > setup-tiles3.log 2>&1
grep -q SETUP-DONE setup-tiles3.log || { echo "setup failed"; exit 1; }
./run7.sh tiles3 tiles3-pair 3 'whole|||' 't4096||| --parse-tile=4096' 't16384||| --parse-tile=16384'
echo QUEUE-DONE
