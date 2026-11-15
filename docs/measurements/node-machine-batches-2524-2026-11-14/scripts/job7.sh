#!/bin/bash
# job7.sh: after job6, two rounds of time-musl.sh: main (m3) without --batch and b2 at batches 1, 256 and 1024.
set -u
cd "$(dirname "$0")"
while ! test -f results/.job6-done; do sleep 30; done
for round in 1 2; do ./time-musl.sh -r$round m3:- b2:1 b2:256 b2:1024; done
date -u +%FT%TZ > results/.job7-done
