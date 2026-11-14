#!/bin/bash
# queue10.sh: the residual a skipped token costs: the probe trees of main (probe) and the head (p6) on the design
# record's preprocessed units, as they are with the skip and with the skipped tokens gone, two rounds, a hold each.
for r in 1 2; do
    for c in musl glibc; do
        timeout 14400 tailscale ssh david@benchpress "cd ~/buster-fast-bench/2531-step3b-claude && EXCLUSIVE_OWNER=claude-2531-step3b EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 bash -c './gone.sh $c i on main$r probe; ./gone.sh $c live off main$r probe; ./gone.sh $c i on head$r p6; ./gone.sh $c live off head$r p6'" 2>&1 | grep -E "^PROBE|^attested" | cut -c1-120
    done
done
echo "=== done"
