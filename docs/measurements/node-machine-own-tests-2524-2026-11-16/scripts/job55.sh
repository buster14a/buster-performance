#!/bin/bash
# job55.sh: where the seventh build's own form spends its cycles: profiles by symbol of o7's sweeps and own runs, and
# the instructions of the function that holds the pass, with their samples.
set -u
cd "$(dirname "$0")"
while systemctl --user is-active -q claude-2524-job54; do sleep 15; done
./own-profile.sh o7 sweeps --front-sweeps --passes 1
./own-profile.sh o7 own --front-own-tests --passes 1
rm -f results/job45.log
./own-annotate.sh o7 own node_front_acted.buster_split --front-own-tests --passes 1 > /dev/null 2>&1
echo "job55 done $(date -u +%FT%TZ)" >> results/job55.log
