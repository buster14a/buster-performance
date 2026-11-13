#!/bin/bash
# chain4.sh: q4.txt after q3.txt's queue ends.
cd "$(dirname "$0")"
until [ -e q3.txt.pid ]; do sleep 5; done
while kill -0 "$(cat q3.txt.pid)" 2>/dev/null; do sleep 10; done
./queue.sh q4.txt
