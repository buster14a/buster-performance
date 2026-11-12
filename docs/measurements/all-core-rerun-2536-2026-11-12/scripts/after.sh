#!/bin/bash
# after.sh: waits for the first queue (its PID file), then runs q2.txt the same way.
cd "$(dirname "$0")"
echo $$ > after.pid
while kill -0 "$(cat q.txt.pid)" 2>/dev/null; do sleep 10; done
exec ./queue.sh q2.txt
