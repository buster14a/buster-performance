#!/bin/bash
# The machine with no node of the walk's, its first run by sweep (2aeb81306): T, the tests, C and X in place.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh 2aeb81306
sleep 20
./alone-split.sh 2aeb81306 7
echo job-complete
