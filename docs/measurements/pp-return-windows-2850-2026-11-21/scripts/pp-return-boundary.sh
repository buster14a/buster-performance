#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;mkdir -p return-boundaries;python3 pp-return-boundary.py
for f in return-boundaries/inputs/*.c;do
 n=$(basename "$f" .c)
 for mode in before stream replay;do
  tag=return;[[ $mode != before ]] || tag=before
  p=$root/return-boundaries/$n-$mode;st=0
  ./lock.sh bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.err"' _ "$p" env BUSTER_TEST_PP_RETURN_WINDOW="$mode" "./return-oracle/$tag" -std=gnu23 -- "$f" >"$p.lock" 2>&1 || st=$?
  echo "$st" >"$p.status"
 done
 s=$(cat "$root/return-boundaries/$n-before.status")
 if [[ $s == 0 ]] && cmp "$root/return-boundaries/$n-before.status" "$root/return-boundaries/$n-stream.status" && cmp "$root/return-boundaries/$n-before.status" "$root/return-boundaries/$n-replay.status" && cmp "$root/return-boundaries/$n-before.data" "$root/return-boundaries/$n-stream.data" && cmp "$root/return-boundaries/$n-before.data" "$root/return-boundaries/$n-replay.data";then echo "$n pass" >>return-boundaries/status;else echo "$n differs" >>return-boundaries/status;fi
done
date -u +%FT%TZ >return-boundaries/done
