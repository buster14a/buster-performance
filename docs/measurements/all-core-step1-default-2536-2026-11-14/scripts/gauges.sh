#!/bin/bash
# gauges.sh COMPILER OUT:OPTIONS...: gauge.sh for each output directory and its options, one after another.
set -u
compiler=$1
shift
cd ~/buster-fast-bench/2536-step1-claude
for spec in "$@"; do
    out=${spec%%:*}
    GAUGE_OPTIONS=${spec#*:} ./gauge.sh "$compiler" "$out"
done
