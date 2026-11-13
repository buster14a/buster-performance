#!/bin/bash
# queue.sh FILE: FILE's lines run one after another, each a command of its own (which takes the lock itself, by
# lock.sh): one hold per run, other sessions' and CI's work between them. Its PID in FILE.pid, a line per command in
# FILE.log; a STOP file in this directory ends it before the next command. #138's record's queue.sh.
cd "$(dirname "$0")"
file=$1
echo $$ > "$file.pid"
while IFS= read -r line; do
    [ -e STOP ] && { echo "stopped before: $line" >> "$file.log"; break; }
    [ -z "$line" ] && continue
    echo "$(date -u +%FT%TZ) start: $line" >> "$file.log"
    bash -c "$line" >> "$file.out" 2>&1
    echo "$(date -u +%FT%TZ) status $?: $line" >> "$file.log"
done < "$file"
echo "$(date -u +%FT%TZ) queue done" >> "$file.log"
