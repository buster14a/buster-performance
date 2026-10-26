#!/bin/bash
# run490.sh: the builds, then five rounds.
B=~/buster-fast-bench/perf-490-claude
"$B/build490.sh"
"$B/queue490.sh" 1 5
