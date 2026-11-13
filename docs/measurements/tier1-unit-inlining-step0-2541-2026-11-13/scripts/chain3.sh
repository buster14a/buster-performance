#!/bin/bash
# chain3.sh: q3.txt after q2.txt's queue ends.
cd "$(dirname "$0")"
until [ -e q2.txt.pid ]; do sleep 5; done
while kill -0 "$(cat q2.txt.pid)" 2>/dev/null; do sleep 10; done
./queue.sh q3.txt
