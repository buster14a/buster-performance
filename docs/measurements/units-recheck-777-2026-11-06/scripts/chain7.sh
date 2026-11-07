#!/bin/bash
cd ~/buster-fast-bench/777-claude-cloud
until grep -q modes-finished modes-texp.log 2>/dev/null; do sleep 5; done
scripts/ab.sh tfinal tmain t763 synth lua musl sqlite
scripts/tests.sh tfinal
