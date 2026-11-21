#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
corpus=$1
out=$PWD/results/lexeradf-kernel-$corpus
test ! -e "$out/order.tsv"
mkdir -p "$out"
case "$corpus" in
 musl) src=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/libc/musl/src ;;
 buster) src=$PWD/pooled-main-source/src/buster/compiler/c_checker_driver.c ;;
 *) exit 2 ;;
esac
if [[ -f $src ]]; then sha256sum "$src" | cut -d' ' -f1 >"$out/source.sha256"; else
 (cd "$src" && find . -type f \( -name '*.c' -o -name '*.h' \) -print0 | sort -z | xargs -0 sha256sum) >"$out/source-manifest.txt"
fi
printf 'round\tposition\tlabel\n' >"$out/order.tsv"
exec 8>our-timing.lock
for n in {1..3}; do
 if ((n%2)); then cases=(prepbase232 lexeradf lexeradf prepbase232); else cases=(lexeradf prepbase232 prepbase232 lexeradf); fi
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
