#!/bin/bash
cd ~/buster-fast-bench/777-claude-cloud
until grep -q tests-finished final3-chain.log 2>/dev/null; do sleep 5; done
scripts/ab.sh tlast tmain t763 synth lua
scripts/tests.sh tlast
