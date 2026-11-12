#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# queue.sh FILE: runs FILE's lines one after another, each a command in its own hold of the lock (lock.sh), with a
# pause between holds so that CI's jobs and other sessions get the machine; detached: (setsid nohup ./queue.sh FILE &).
cd "$(dirname "$0")"
file=${1:?a queue}
echo $$ > "$file.pid"
while IFS= read -r line; do
    if [[ -z $line || $line == \#* ]]; then continue; fi
    start=$(date -u +%FT%TZ)
    ./lock.sh $line >> "$file.log" 2>&1 < /dev/null
    echo "$start $line: status $? ended $(date -u +%FT%TZ)" >> "$file.done"
    sleep 15
done < "$file"
echo "queue ended $(date -u +%FT%TZ)" >> "$file.done"
