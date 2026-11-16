#!/bin/bash
set -u
cd "$(dirname "$0")"
./own-instructions.sh o1 sweeps --front-sweeps --passes 1
./own-instructions.sh o1 tests --front-tests --passes 1
./own-instructions.sh o1 own --front-own-tests --passes 1
echo "job47 done $(date -u +%FT%TZ)" >> results/job47.log
