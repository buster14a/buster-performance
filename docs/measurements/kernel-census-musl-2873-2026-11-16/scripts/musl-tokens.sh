#!/bin/bash
# musl-tokens.sh: each unit's preprocessed tokens (its --time-stages report's `time-process tokens`) and its source's
# bytes, a line a unit in the loop's order (results/musl/tokens.tsv). In one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source scripts/musl-common.sh
out=results/musl
mkdir -p "$out"
compiler=$here/src/build/compiler
status=0
printf 'unit\tsource\tbytes\ttokens\n' > "$out/tokens.tsv"
for i in "${!files[@]}"; do
    f=${files[i]}
    tokens=$(taskset -c 2 "$compiler" "${options[@]}" --time-stages -c "$f" -o /dev/shm/2873-musl-tokens.o 2>&1 > /dev/null | awk -F'\t' '$1 == "time-process" && $2 == "tokens" {print $3}')
    [[ -n $tokens ]] || status=1
    printf '%d\t%s\t%d\t%s\n' "$i" "${f#$musl/}" "$(stat -c %s "$f")" "${tokens:-?}" >> "$out/tokens.tsv"
done
rm -f /dev/shm/2873-musl-tokens.o
exit $status
