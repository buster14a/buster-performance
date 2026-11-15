#!/bin/bash
# job3.sh: counts-g.sh for b1o at batches 1, 16 and 256, each batch size one hold of the lock.
set -u
cd "$(dirname "$0")"
for b in 1 16 256; do ./counts-g.sh b1o $b; done
date -u +%FT%TZ > results/.job3-done
