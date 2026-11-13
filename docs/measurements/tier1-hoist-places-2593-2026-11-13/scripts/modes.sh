#!/usr/bin/env bash
# modes.sh COMPILER TAG MODE...: both.sh for each BUSTER_X2593 mode into runs/TAG-mMODE.
B=$1; tag=$2; shift 2
for m in "$@"; do
  BUSTER_X2593=$m bash ~/.cache/claude-2593/scripts/both.sh $B ~/.cache/claude-2593/runs/$tag-m$m > ~/.cache/claude-2593/runs/$tag-m$m.log 2>&1
  echo "mode $m done: $(head -1 ~/.cache/claude-2593/runs/$tag-m$m.log | sed 's/.*instructions //') st, $(grep total ~/.cache/claude-2593/runs/$tag-m$m.log)"
done
