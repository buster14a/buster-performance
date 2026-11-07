#!/bin/bash
cd ~/buster-fast-bench/777-claude-cloud
until grep -q ab-finished ab-thead.log 2>/dev/null; do sleep 5; done
scripts/modes.sh texp synth lua musl
