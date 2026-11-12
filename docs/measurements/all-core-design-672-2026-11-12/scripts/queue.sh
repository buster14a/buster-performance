#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# queue.sh FILE [PAUSE]: runs each line of FILE as a command of this directory, each inside its own hold of the 9700X's
# lock (lock.sh), with PAUSE seconds (default 20) between holds so that CI and other sessions get the machine. Writes
# its process ID to FILE.pid, a line a command to FILE.log (its start, end and status), and `done` last.
set -u
cd "$(dirname "$0")"
file=${1:?a queue file}
pause=${2:-20}
echo $$ > "$file.pid"
while IFS= read -r line; do
    [[ -z $line || $line == \#* ]] && continue
    echo "start $(date -u +%T) $line" >> "$file.log"
    # shellcheck disable=SC2086
    ./lock.sh $line >> "$file.out" 2>&1
    echo "end $(date -u +%T) status $? $line" >> "$file.log"
    sleep "$pause"
done < "$file"
echo "done $(date -u +%T)" >> "$file.log"
