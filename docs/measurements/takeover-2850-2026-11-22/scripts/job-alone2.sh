#!/bin/bash
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh 089225001
sleep 20
./alone.sh 089225001 7
echo job-complete
