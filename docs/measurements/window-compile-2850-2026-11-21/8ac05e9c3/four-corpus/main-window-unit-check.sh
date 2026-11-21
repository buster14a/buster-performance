#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
top=$PWD; label=$1; corpus_name=$2
out=$top/results/units-window-$label-$corpus_name
test ! -e "$out/checks.tsv"; mkdir -p "$out"
source ./corpora.sh
main_arguments="-march=native -I$top/pooled-main-source/src -fwrapv -funsigned-char --predefines $top/proof-predefines.h $top/pooled-main-source/src/buster/compiler/main.c"
v=${corpus_name}_arguments;eval "args=(${!v})";printf '%s\0' "${args[@]}" > "$out/args.nul"
case "$corpus_name" in lua) units=34;; musl) units=1336;; main|sqlite) units=1;; *) exit 2;; esac
scratch=$(mktemp -d /dev/shm/buster2850-unit.XXXXXXXX)
trap 'rm -f "$scratch/unit.o"; rmdir "$scratch"' EXIT
printf 'object\tpolicy\tmode\ttokens\tstatus\tobject-bytes\tobject-sha256\tstdout-bytes\tstdout-sha256\tstderr-bytes\tstderr-sha256\ttaken\tordinary-nodes-replaced\tsummary-nodes\tfinal-graph-nodes\n' > "$out/checks.tsv"
for ((i=0;i<units;i+=24)); do
 ./lock.sh taskset -c 2 python3 main-window-unit-check.py "$top/results/$label/compiler" "$out/args.nul" "$i" 24 "$scratch" > "$out/part-$i.tsv" 2> "$out/part-$i.lock"
 cat "$out/part-$i.tsv" >> "$out/checks.tsv"
done
test "$(wc -l < "$out/checks.tsv")" = "$((1+6*units))"
echo COMPLETE
