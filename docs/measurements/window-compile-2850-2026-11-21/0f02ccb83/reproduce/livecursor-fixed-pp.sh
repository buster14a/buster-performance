#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2;top=$PWD
d=$top/results/livecursor-fixed-preprocess;mkdir -p "$d"
source ./corpora.sh
eval "args=($sqlite_arguments)"
for r in 1 2 3;do
 if ((r%2));then arms=(factsmain0e1d livegroupfixed livegroupfixed factsmain0e1d);else arms=(livegroupfixed factsmain0e1d factsmain0e1d livegroupfixed);fi
 # One short interleaved round holds the machine lease across the four arms.
 ./lock.sh bash -c '
  set -e
  d=$1; r=$2; shift 2
  arms=("${@:1:4}"); shift 4
  for i in 0 1 2 3; do
   label=${arms[i]}
   taskset -c 2 "results/$label/compiler" benchmark-preprocessor --only vectorized "$@" >"$d/$r-$i-$label.log" 2>&1
  done
 ' _ "$d" "$r" "${arms[@]}" "${args[@]}" >"$d/round-$r.lock" 2>&1
done
