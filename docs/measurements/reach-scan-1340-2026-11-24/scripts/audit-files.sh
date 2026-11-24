#!/bin/bash
# For each fault given, the files (of a list) whose compile fails the reach filter's audit under it.
# Arguments: the fault build, the file list, the output, then the faults' numbers.
compiler=$1; list=$2; out=$3; shift 3
for fault in "$@"; do
    caught=$(BUSTER_EXPERIMENT_REACH_FAULT=$fault BUSTER_TEST_COMMON_REACH_AUDIT=1 xargs -P 4 -a "$list" -d '\n' -n 8 bash -c 'for f in "$@"; do "$0" --lanes 1 -fsyntax-only -Wall -Wextra -Wno-sign-compare "$f" 2>&1 | grep -q "reach filter audit" && echo "$f"; done' "$compiler" | sort)
    echo "$fault	$(echo -n "$caught" | grep -c .)	$(echo "$caught" | head -2 | tr '\n' ' ')" >> "$out"
done
