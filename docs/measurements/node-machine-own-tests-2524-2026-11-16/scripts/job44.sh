#!/bin/bash
# job44.sh: where the own form's cycles are: profiles of o1's three runs on sqlite3.c.
set -u
cd "$(dirname "$0")"
./own-profile.sh o1 sweeps --front-sweeps --passes 1
./own-profile.sh o1 tests --front-tests --passes 1
./own-profile.sh o1 own --front-own-tests --passes 1
echo "job44 done $(date -u +%FT%TZ)" >> results/job44.log
