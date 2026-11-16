#!/bin/bash
# profiles.sh LABEL NAME PASSES [shadow options]: profile.sh's three profiles (cycles, instructions, mispredicted
# branches) of LABEL's kernel with the options, under NAME.
cd "$(dirname "$0")"
label=$1; name=$2; passes=$3
shift 3
for event in "cycles 200003" "instructions 400009" "branch-misses 1009"; do
    e=${event% *}
    period=${event#* }
    ./profile.sh "$label" "$name" $passes $e $period "$@" > /dev/null 2>&1
done
echo profiles-done $label $name
