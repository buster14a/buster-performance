#!/bin/bash
# The machine with no node of the walk's, its first run by sweep (b3bb0de89): T, the tests, C and X in place.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh b3bb0de89
sleep 20
./alone.sh b3bb0de89 7
echo job-complete
