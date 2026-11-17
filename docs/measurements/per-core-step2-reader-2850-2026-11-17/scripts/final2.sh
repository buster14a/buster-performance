#!/bin/bash
# final2.sh: the commit's own sources (final2.patch against main 178c9e2): the piece's readings (job.sh), then -c
# sqlite3.c as whole processes against the base (main with buster#2894 and buster#2890: base.patch), twice.
cd "$(dirname "$0")"
./job.sh final2 final2.patch 5 || exit 1
./compile.sh base final2 2 || exit 1
echo final2 finished
