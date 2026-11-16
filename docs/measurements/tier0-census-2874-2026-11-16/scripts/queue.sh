#!/bin/bash
# queue.sh FILE: runs FILE's lines one after another (each a runner of this directory, which takes the lock itself, a
# hold a run), with 20 s between them so that a waiting CI job or session gets the machine; a line's output in
# queue.log. A file named STOP in this directory ends the queue before its next line.
cd "$(dirname "$0")"
while IFS= read -r line; do
    [ -z "$line" ] && continue
    [ -e STOP ] && { echo "$(date -u +%FT%TZ) stopped" >> queue.log; break; }
    echo "$(date -u +%FT%TZ) $line" >> queue.log
    bash -c "$line" >> queue.log 2>&1
    echo "$(date -u +%FT%TZ) status $?" >> queue.log
    sleep 20
done < "$1"
echo "$(date -u +%FT%TZ) queue $1 done" >> queue.log
