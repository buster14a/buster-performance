#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;mkdir -p returnguard-boundaries;python3 pp-return-boundary-guard.py
for f in returnguard-boundaries/inputs/*.c;do
 n=$(basename "$f" .c)
 for mode in before stream replay;do
  tag=returnguard;[[ $mode != before ]] || tag=before
  p=$root/returnguard-boundaries/$n-$mode;st=0
  ./lock.sh bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.data" 2>"$p.err"' _ "$p" env BUSTER_TEST_PP_RETURN_WINDOW="$mode" "./returnguard-oracle/$tag" -std=gnu23 -- "$f" >"$p.lock" 2>&1 || st=$?
  echo "$st" >"$p.status"
 done
 s=$(cat "$root/returnguard-boundaries/$n-before.status")
 if [[ $s == 0 ]] && cmp "$root/returnguard-boundaries/$n-before.status" "$root/returnguard-boundaries/$n-stream.status" && cmp "$root/returnguard-boundaries/$n-before.status" "$root/returnguard-boundaries/$n-replay.status" && cmp "$root/returnguard-boundaries/$n-before.data" "$root/returnguard-boundaries/$n-stream.data" && cmp "$root/returnguard-boundaries/$n-before.data" "$root/returnguard-boundaries/$n-replay.data";then echo "$n pass" >>returnguard-boundaries/status;else echo "$n differs" >>returnguard-boundaries/status;fi
done
date -u +%FT%TZ >returnguard-boundaries/done
