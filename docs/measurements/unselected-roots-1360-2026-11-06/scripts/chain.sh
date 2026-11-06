#!/bin/bash
cd ~/buster-fast-bench/1360-opencode
while kill -0 2830134 2>/dev/null; do sleep 10; done
grep -q "^done" build-trees.log || { echo "builds failed"; exit 1; }
./measure.sh
