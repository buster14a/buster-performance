#!/bin/bash
# run3.sh: run2.sh's last steps again, after benchpress's /home filled up during them (results/failed-disk-full).
set -u
cd "$(dirname "$0")"
./time.sh head
./ab.sh split head
./extra.sh main head
date -u +%FT%TZ > results/.all-done-3
