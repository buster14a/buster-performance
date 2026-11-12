#!/bin/bash
# queue.sh NAME COMMAND...: runs each COMMAND (one quoted string each) in turn, each inside its own hold of the lock
# (lock.sh), detached from the caller; logs to queue-NAME.log, its PID in queue-NAME.pid, and writes queue-NAME.done
# when the last one ends. Start it with: (setsid nohup ./queue.sh NAME 'cmd1' 'cmd2' > /dev/null 2>&1 < /dev/null &)
cd "$(dirname "$0")"
name=$1; shift
echo $$ > "queue-$name.pid"
rm -f "queue-$name.done"
{
    for command in "$@"; do
        echo "== $(date -u +%FT%TZ) start: $command"
        ./lock.sh bash -c "$command"
        echo "== $(date -u +%FT%TZ) status $?: $command"
    done
} > "queue-$name.log" 2>&1
date -u +%FT%TZ > "queue-$name.done"
