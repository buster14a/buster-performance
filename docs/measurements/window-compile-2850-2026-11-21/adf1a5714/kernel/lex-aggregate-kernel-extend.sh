#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
out=$PWD/results/lexeradf-kernel
test "$(wc -l < "$out/order.tsv")" = 25
grep -Fxq COMPLETE lexeradf-kernel.log
mkdir -p "$out"
src=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
sha256sum "$src" | cut -d' ' -f1 >"$out/source.sha256"
wc -c < "$src" >"$out/source.bytes"

exec 8>our-timing.lock
for n in {4..7}; do
 case "$n" in
  4|7) cases=(prepbase232 lexer220 lexer8b3 lexeradf lexeradf lexer8b3 lexer220 prepbase232);;
  5) cases=(lexer8b3 lexer220 prepbase232 lexeradf lexeradf prepbase232 lexer220 lexer8b3);;
  6) cases=(lexeradf prepbase232 lexer8b3 lexer220 lexer220 lexer8b3 prepbase232 lexeradf);;
 esac
 flock -x 8
 i=0
 for label in "${cases[@]}"; do
  i=$((i+1))
  prefix=$out/$n-$i
  ./lock.sh taskset -c 2 bash -c 'exe=$1; src=$2; stem=$3; exec "$exe" benchmark-lexer "$src" >"$stem.stdout" 2>"$stem.stderr"' _ "$PWD/results/$label/compiler" "$src" "$prefix" >"$prefix.lock" 2>&1
  test ! -s "$prefix.stderr"
  grep -Eq 'corpus: 0 files differ' "$prefix.stdout"
  grep -Eq 'instructions/B' "$prefix.stdout"
  printf '%s\t%s\t%s\n' "$n" "$i" "$label" >>"$out/order.tsv"
 done
 flock -u 8
done
echo COMPLETE
