#!/bin/bash
# job5.sh: time-orders-g.sh for b1v, two rounds, each one hold of the lock.
set -u
cd "$(dirname "$0")"
for round in 1 2; do ./time-orders-g.sh b1v -r$round; done
date -u +%FT%TZ > results/.job5-done
