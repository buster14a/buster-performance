#!/bin/bash
# queue.sh: step.sh's calls in order, each one hold of the lock.
here=$(cd "$(dirname "$0")" && pwd)
export EXCLUSIVE_OWNER=claude-2769
export EXCLUSIVE_TITLE="buster #2769: attested declarations' lists by a vector path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2769
for call in "$@"; do
    set -- $call
    ~/buster-fast-bench/exclusive.sh timeout -k 5 1500 "$here/step.sh" "$@" >> "$here/queue.log" 2>&1
    echo "$call $?" >> "$here/queue.log"
done
echo "queue done" >> "$here/queue.log"
