#!/bin/bash
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
rm -rf results/locality-fix1
./locality.sh fix1 fix1 5 4 16 64
echo job-complete
