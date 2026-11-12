#!/bin/bash
# go.sh: the build (one hold), then the queue (one hold a line).
cd "$(dirname "$0")"
echo $$ > go.pid
./build.sh src
if grep -q "^build exit 0" build-src.log; then ./queue.sh q-round1.txt; fi
./env.sh > env.txt 2>&1
echo go done >> go.log
