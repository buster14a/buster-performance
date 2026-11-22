#!/bin/bash
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh 6d5a8087b
sleep 20
./alone.sh 6d5a8087b 7
echo job-complete
