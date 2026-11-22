#!/bin/bash
# The body boundary scaffold with the resolution kept (cc5d1f8c4): the frozen sqlite3.c, ordinary, supplied and masked,
# supplied and resolved.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh cc5d1f8c4
sleep 20
./boundary4.sh cc5d1f8c4 7
python3 boundary-reduce.py results/boundary-resolve-cc5d1f8c4 whole supplied resolved > results/boundary-resolve-cc5d1f8c4/summary.txt 2>&1
echo job-complete
