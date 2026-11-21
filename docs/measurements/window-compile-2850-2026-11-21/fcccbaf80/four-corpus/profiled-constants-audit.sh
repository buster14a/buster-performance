#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
top=$PWD;g=$1
case $g in main|sqlite)n=1;;lua)n=34;;musl)n=1336;;*)exit 2;;esac
out=$top/results/constant-sources-constfcc-$g;test ! -e "$out/checks.tsv";mkdir -p "$out"
source ./corpora.sh
main_arguments="-march=native -I$top/pooled-main-source/src -fwrapv -funsigned-char --predefines $top/proof-predefines.h $top/pooled-main-source/src/buster/compiler/main.c"
v=${g}_arguments;eval "args=(${!v})";printf '%s\0' "${args[@]}" >"$out/args.nul"
d=$(mktemp -d /dev/shm/buster2850-unit.XXXXXXXX)
trap 'rm -f "$d/unit.o"; rmdir "$d"' EXIT
printf 'object\ttokens\troots\tremoved\tgraph-nodes\tobject-bytes\tobject-sha256\n' >"$out/checks.tsv"
for ((i=0;i<n;i+=60));do
 ./lock.sh taskset -c 2 python3 constants-unit-check.py "$top/results/constfcc/compiler" "$out/args.nul" "$i" 60 "$d" >"$out/part-$i.tsv" 2>"$out/part-$i.lock"
 cat "$out/part-$i.tsv" >>"$out/checks.tsv"
done
test "$(wc -l < "$out/checks.tsv")" = "$((n+1))"
echo COMPLETE
