#!/bin/bash
# job46.sh: what the three runs retire and miss: o1's sweeps, census tests and own tests on sqlite3.c.
set -u
cd "$(dirname "$0")"
./own-stat.sh o1 sweeps --front-sweeps --passes 1
./own-stat.sh o1 tests --front-tests --passes 1
./own-stat.sh o1 own --front-own-tests --passes 1
echo "job46 done $(date -u +%FT%TZ)" >> results/job46.log
