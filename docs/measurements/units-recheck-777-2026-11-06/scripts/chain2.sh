#!/bin/bash
cd ~/buster-fast-bench/777-claude-cloud
until grep -q profile-finished profile-tmain.log; do sleep 5; done
scripts/attribute.sh tmain t763 lua synth musl
