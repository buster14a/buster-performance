#!/bin/bash
cd ~/buster-fast-bench/777-claude-cloud
until grep -q final-finished final-tmain.log; do sleep 5; done
scripts/tests.sh tmain
