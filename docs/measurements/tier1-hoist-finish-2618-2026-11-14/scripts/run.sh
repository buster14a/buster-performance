#!/usr/bin/env bash
# run.sh MODE...: speedtest1 and Lua counts by c-exp2 with BUSTER_X2618=MODE, into runs3/xMODE.
for m in "$@"; do
  BUSTER_X2618=$m bash ~/.cache/claude-2618b/scripts/both.sh ~/.cache/claude-2618b/c-exp2 ~/.cache/claude-2618b/runs3/x$m > ~/.cache/claude-2618b/runs3/x$m.log 2>&1
  echo "x$m $(tail -8 ~/.cache/claude-2618b/runs3/x$m.log | tr '\n' ' ')" >> ~/.cache/claude-2618b/runs3/summary.txt
done
