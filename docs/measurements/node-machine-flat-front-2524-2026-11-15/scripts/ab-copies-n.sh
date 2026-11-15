#!/bin/bash
# ab-copies-n.sh BASE HEAD N: ab-copies.sh N times, each comparison kept apart (results/ab-copies-BASE-HEAD-K).
set -u
cd "$(dirname "$0")"
base=$1; head=$2; n=$3
for k in $(seq 1 $n); do
    ./ab-copies.sh $base $head
    rm -rf results/ab-copies-$base-$head-$k
    mv results/ab-copies-$base-$head results/ab-copies-$base-$head-$k
done
