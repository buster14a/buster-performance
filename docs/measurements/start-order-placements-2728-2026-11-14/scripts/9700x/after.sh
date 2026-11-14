#!/bin/bash
# after.sh PIDFILE QUEUE: runs QUEUE (queue.sh) once the queue whose PID PIDFILE holds has ended.
while kill -0 $(cat "$1") 2>/dev/null; do sleep 10; done
exec /home/david/buster-fast-bench/2559-step5b-claude/scripts/queue.sh "$2"
