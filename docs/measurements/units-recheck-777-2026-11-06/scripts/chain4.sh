#!/bin/bash
cd ~/buster-fast-bench/777-claude-cloud
until grep -q tests-finished tests-tmain.log; do sleep 5; done
scripts/quiet.sh tmain t763
