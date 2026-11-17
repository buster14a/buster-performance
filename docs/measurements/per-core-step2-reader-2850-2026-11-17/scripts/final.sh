#!/bin/bash
# final.sh: the commit's own sources (final.patch against main 178c9e2): the piece's readings (job.sh), then -c sqlite3.c
# as whole processes against the base (main with buster#2894 and buster#2890: base.patch), twice.
cd "$(dirname "$0")"
./job.sh final final.patch 5 || exit 1
./compile.sh base final 2 || exit 1
echo final finished
