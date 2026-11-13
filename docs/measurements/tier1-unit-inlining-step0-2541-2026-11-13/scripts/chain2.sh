#!/bin/bash
# chain2.sh: q2.txt after q1.txt's queue ends (waits on its PID).
cd "$(dirname "$0")"
while kill -0 "$(cat q1.txt.pid)" 2>/dev/null; do sleep 10; done
./queue.sh q2.txt
