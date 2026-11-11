#!/bin/bash
B=$HOME/buster-fast-bench/2089-claude
until grep -q "^base build exit" $B/logs/builds.txt 2>/dev/null; do sleep 5; done
$B/loop.sh c1 40 perf base main
$B/loop.sh c1 40 plain base main
