#!/bin/bash
# campaign-all.sh: four campaigns of 150 programs per generator each (seeds 1000..1599), detached; diff/run-R.log.
cd "$HOME/.cache/claude-2541"
for r in 0 1 2 3; do
    seed=$((1000 + r * 150))
    (nice bin/campaign.sh "$HOME/.cache/claude-2541/compiler-campaign" $seed 150 diff/run-$r > diff/run-$r.log 2>&1; echo "exit $?" >> diff/run-$r.log) &
done
wait
date -u +%FT%TZ > diff/done
