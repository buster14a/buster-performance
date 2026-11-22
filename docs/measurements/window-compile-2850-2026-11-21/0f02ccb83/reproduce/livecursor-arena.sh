#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
top=$PWD
out=$top/results/livecursor-arena-sqlite
mkdir -p "$out"
scratch=$(mktemp -d "$top/results/cursor-arena.XXXXXX")
trap 'rm -f -- "$scratch"/*.o; rmdir "$scratch"' EXIT
for kind in preflight policy;do
 ./lock.sh taskset -c 2 bash livegroupcache-one.sh livegroupcache sqlite candidate "$kind" "$out/$kind-cache" "$scratch" >"$out/$kind.lock" 2>&1
 for suffix in objects stdout stderr;do
  cmp "results/ordinary-pair-livegroupfixed-sqlite/$kind-baseline.$suffix" "$out/$kind-cache.$suffix"
 done
done
for r in 1 2 3;do
 case $r in
  1) arms=(baseline fixed cache cache fixed baseline);;
  2) arms=(cache baseline fixed fixed baseline cache);;
  3) arms=(fixed cache baseline baseline cache fixed);;
 esac
 ./lock.sh taskset -c 2 bash -c '
 set -e
 d=$1; r=$2; scratch=$3;shift 3
 i=0
 for arm in "$@";do
  stem=$d/$r-$i-$arm
  case $arm in
   baseline) label=livegroupfixed; mode=baseline;;
   fixed) label=livegroupfixed;mode=candidate;;
   cache) label=livegroupcache;mode=candidate;;
  esac
  bash "$label-one.sh" "$label" sqlite "$mode" wall "$stem" "$scratch"
  cmp results/ordinary-pair-livegroupfixed-sqlite/preflight-baseline.objects "$stem.objects"
  i=$((i+1))
 done
 ' _ "$out" "$r" "$scratch" "${arms[@]}" >"$out/$r.lock" 2>&1
done
