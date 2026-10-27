#!/bin/bash
# Runs a command and appends its wall time and status to standard error.
start=$(date +%s.%N)
"$@"
status=$?
end=$(date +%s.%N)
echo "timed: status $status seconds $(awk "BEGIN { print $end - $start }")" >&2
exit $status
