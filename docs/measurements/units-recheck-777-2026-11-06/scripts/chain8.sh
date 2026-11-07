#!/bin/bash
cd ~/buster-fast-bench/777-claude-cloud
until grep -q tests-finished tests-tfinal.log 2>/dev/null || grep -q tests-finished final-chain.log 2>/dev/null; do sleep 5; done
scripts/ab.sh tfinal3 tmain t763 synth lua musl sqlite
scripts/tests.sh tfinal3
