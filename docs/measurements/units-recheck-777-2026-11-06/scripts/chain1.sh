#!/bin/bash
cd ~/buster-fast-bench/777-claude-cloud
until grep -q measure-finished measure-tmain.log; do sleep 5; done
scripts/profile.sh tmain t763
