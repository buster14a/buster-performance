#!/bin/bash
# queue.sh FILE: runs each line of FILE as a command under its own hold of the lock, in order, logging to FILE.log.
cd "$(dirname "$0")"
echo $$ > "$1.pid"
while IFS= read -r line; do
    [ -z "$line" ] && continue
    echo "== $(date -u +%FT%TZ) $line" >> "$1.log"
    # shellcheck disable=SC2086
    ./lock.sh $line >> "$1.log" 2>&1
    echo "== exit $? $(date -u +%FT%TZ)" >> "$1.log"
done < "$1"
echo "queue done $(date -u +%FT%TZ)" >> "$1.log"
