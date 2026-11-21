#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
group=$1; out=$PWD/results/full-chain-tokens-$group; mkdir -p "$out"
source ./corpora.sh
v=${group}_arguments; eval "args=(${!v})"
printf '%s\0' "${args[@]}" > "$out/args.nul"
scratch=$(mktemp -d /dev/shm/buster2850-tokenaudit.XXXXXXXX);trap 'rm -f "$scratch/unit.o"; rmdir "$scratch"' EXIT
case $group in lua) count=34;;musl)count=1336;;esac
printf 'object\ttokens\tbytes\tsha256\n' > "$out/tokens.tsv"
for ((i=0;i<count;i+=32)); do
 ./lock.sh taskset -c 2 python3 full-chain-tokens.py "$PWD/results/chainprbase6e9/compiler" "$out/args.nul" "$i" "$scratch" > "$out/batch-$i.tsv" 2> "$out/batch-$i.lock"
 cat "$out/batch-$i.tsv" >> "$out/tokens.tsv"
done
test "$(wc -l < "$out/tokens.tsv")" = "$((count+1))"
echo COMPLETE
