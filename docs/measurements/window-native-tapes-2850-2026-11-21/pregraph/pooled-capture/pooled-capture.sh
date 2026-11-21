#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
out=$PWD/results/pooled-capture
test ! -e "$out/order.tsv"; mkdir -p "$out/verify"
printf 'corpus\tround\tposition\tmode\n' > "$out/order.tsv"
run() {
 local group=$1 tag=$2 stem=$3 audit=$4
 ./lock.sh taskset -c 2 bash pooled-capture-one.sh "$group" "$tag" "$stem" "$audit" >"$stem.lock" 2>&1 || { echo "failed $stem"; return 1; }
}
for group in sqlite lua musl main; do
 for tag in uncached cached pooled; do
  run "$group" "$tag" "$out/verify/$group-$tag" check
  cmp "$out/verify/$group-uncached.receipt" "$out/verify/$group-$tag.receipt"
 done
done
for fault in class variadic symbol argument; do run sqlite pooled "$out/verify/mutation-$fault" "$fault"; done
exec 9>our-timing.lock
for round in {1..7}; do
 for group in sqlite lua musl main; do
  case $(((round-1)%3)) in
   0) order=(uncached cached pooled pooled cached uncached);;
   1) order=(cached pooled uncached uncached pooled cached);;
   2) order=(pooled uncached cached cached uncached pooled);;
  esac
  flock -x 9
  for i in 0 1 2 3 4 5; do
   tag=${order[i]};stem="$out/$group-$round-$i-$tag"
   run "$group" "$tag" "$stem" off
   cmp "$out/verify/$group-uncached.receipt" "$stem.receipt"
   printf '%s\t%s\t%s\t%s\n' "$group" "$round" "$i" "$tag" >> "$out/order.tsv"
  done
  flock -u 9
 done
done
echo COMPLETE
