#!/bin/bash
# queue.sh FILE: runs FILE's lines in order, each its own hold of the lock (common.sh's lock); logs to FILE.log.
set -u
cd "$(dirname "$0")"
. ./common.sh
while read -r name command; do
    [[ -z $name || $name == \#* ]] && continue
    echo "== $(date -u +%T) $name: $command" >> "$1.log"
    lock "$name" bash -c "$command" >> "$1.log" 2>&1
    echo "== $(date -u +%T) $name: status $?" >> "$1.log"
done < "$1"
echo "== done" >> "$1.log"
