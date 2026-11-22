#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2; root=$PWD
out=$PWD/results/active-source-screens;mkdir -p "$out"
source corpora.sh;eval "args=($sqlite_arguments)"
for round in 1 2 3;do
 case $round in
  1) arms=(eager line islands tiles tiles islands line eager);;
  2) arms=(islands tiles eager line line eager tiles islands);;
  3) arms=(tiles eager line islands islands line eager tiles);;
 esac
 ./lock.sh taskset -c 2 bash -c '
  set -e
  root=$1; out=$2; round=$3; shift 3
  arms=("${@:1:8}"); shift 8
  for i in {0..7};do
   name=${arms[i]}
   case $name in
    eager) bin=$root/results/active-source-profile/pinned;;
    line) bin=$root/results/active-direct-pilot/pilot;;
    islands) bin=$root/results/active-direct-islands/pilot;;
    tiles) bin=$root/results/active-direct-tiles/pilot;;
   esac
   for sample in 1 2 3 4 5;do "$bin" "$@" >>"$out/$round-$i-$name.tsv";done
  done
 ' _ "$root" "$out" "$round" "${arms[@]}" "${args[@]}" >"$out/$round.lock" 2>&1
done
