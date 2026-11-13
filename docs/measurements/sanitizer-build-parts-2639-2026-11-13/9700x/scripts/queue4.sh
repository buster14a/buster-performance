#!/bin/bash
# After queue3: Release without debug information on main and on the branch, whose executables must be the same bytes.
cd ~/buster-fast-bench/2639-claude
while pgrep -x queue3.sh > /dev/null; do sleep 10; done
./release-build.sh release-g0-main src
./release-build.sh release-g0-split split
