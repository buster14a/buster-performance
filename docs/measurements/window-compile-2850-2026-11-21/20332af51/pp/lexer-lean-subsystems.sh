#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
kind=$1; out=$PWD/results/lexer203-$kind
test ! -e "$out/order.tsv";mkdir -p "$out"
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
case $kind in
 lexer) args=(benchmark-lexer "$sql/sqlite3.c");;
 pp) args=(benchmark-preprocessor --only vectorized -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql" "$sql/sqlite3.c");;
 *) exit 2;;
esac
printf 'round\tposition\tlabel\n' >"$out/order.tsv"
exec 8>our-timing.lock
for n in {1..3}; do
 case "$n" in
  1) cases=(constbaseb86 lexera16 lexer203 lexer203 lexera16 constbaseb86);;
  2) cases=(lexer203 constbaseb86 lexera16 lexera16 constbaseb86 lexer203);;
  3) cases=(lexera16 lexer203 constbaseb86 constbaseb86 lexer203 lexera16);;
 esac
 flock -x 8
 i=0
 for label in "${cases[@]}"; do
  i=$((i+1));stem=$out/$n-$i
  ./lock.sh taskset -c 2 bash -c 'stem=$1; shift; exec "$@" >"$stem.stdout" 2>"$stem.stderr"' _ "$stem" "$PWD/results/$label/compiler" "${args[@]}" >"$stem.lock" 2>&1
  test ! -s "$stem.stderr"
  case $kind in lexer) grep -q 'corpus: 0 files differ' "$stem.stdout";; pp) grep -q 'cycles/input token' "$stem.stdout";; esac
  printf '%s\t%s\t%s\n' "$n" "$i" "$label" >>"$out/order.tsv"
 done
 flock -u 8
done
echo COMPLETE
