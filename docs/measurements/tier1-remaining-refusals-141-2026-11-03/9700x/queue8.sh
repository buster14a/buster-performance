#!/usr/bin/env bash
# queue8.sh: after bisect7, build head-ldscan, then perf stat head-vscan against head-ldscan (bisect8).
cd ~/buster-fast-bench/claude-141-wide || exit 1
until [ -f bisect7/done ]; do sleep 20; done
./build.sh head-ldscan
BISECT_OUT=bisect8 ./bisect.sh head-vscan head-ldscan
