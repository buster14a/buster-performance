#!/bin/bash
# Waits for ab2.sh to finish, sets its invalid tier1 log aside, and runs ab3.sh's corrected tier1 step.
cd "$HOME/buster-fast-bench/866-claude" || exit 1
while pgrep -f '[s]cripts/ab2.sh' > /dev/null; do sleep 20; done
mv results/tier1.log results/tier1-invalid-arguments.log
./scripts/ab3.sh tier1
