#!/bin/bash
# chain.sh PID LOG STEP...: waits for the process PID (a queue that runs before) to end, then runs queue2.sh LOG STEP...
while kill -0 "$1" 2> /dev/null; do
    sleep 10
done
shift
exec ~/buster-fast-bench/build-270-claude/queue2.sh "$@"
