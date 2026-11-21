#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
out=$PWD/results/lexeradf-pp-kernel
test ! -e "$out/order.tsv";mkdir -p "$out"
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cmd=(benchmark-preprocessor --only vectorized -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql" "$sql/sqlite3.c")
printf 'round\tposition\tlabel\n' >"$out/order.tsv"
exec 8>our-timing.lock
for n in {1..3}; do
 if ((n%2)); then cases=(prepbase232 lexeradf lexeradf prepbase232); else cases=(lexeradf prepbase232 prepbase232 lexeradf); fi
 flock -x 8
 i=0
 for lab in "${cases[@]}"; do
  i=$((i+1));stem=$out/$n-$i
  ./lock.sh taskset -c 2 bash -c 'stem=$1; shift; exec "$@" >"$stem.stdout" 2>"$stem.stderr"' _ "$stem" "$PWD/results/$lab/compiler" "${cmd[@]}" >"$stem.lock" 2>&1
  test ! -s "$stem.stderr"
  grep -q 'cycles/input token' "$stem.stdout"
  printf '%s\t%s\t%s\n' "$n" "$i" "$lab" >>"$out/order.tsv"
 done
 flock -u 8
done
echo COMPLETE
