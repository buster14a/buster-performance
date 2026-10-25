#!/bin/bash
# ab-chain.sh PID LOG ROUNDS: waits for the process PID (the queue whose builds leave the trees' compilers) to end, then
# runs ab.sh LOG ROUNDS.
while kill -0 "$1" 2> /dev/null; do
    sleep 10
done
exec ~/buster-fast-bench/build-270-claude/ab.sh "$2" "$3"
