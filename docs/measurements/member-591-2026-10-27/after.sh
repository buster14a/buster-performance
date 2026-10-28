#!/bin/bash
# after.sh PID FILE: runs queue.sh FILE once process PID has ended.
while kill -0 "$1" 2>/dev/null; do sleep 5; done
exec ./queue.sh "$2"
