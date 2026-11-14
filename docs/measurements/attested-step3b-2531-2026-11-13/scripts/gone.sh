#!/bin/bash
# gone.sh CORPUS SET WAY LABEL TREE: the probe tree TREE's --attested=WAY of the design record's preprocessed units
# (../672-rest-claude/scratch/CORPUS-SET: SET i, as they are, or live, the emulation's skipped tokens gone) as one
# command on CPU 2, with BUSTER_PROBE_PHASES=1 and --time-stages: the last unit's sums of the phases' ticks and the
# attested declarations' counts, into results/gone-CORPUS-SET-WAY-LABEL.txt (the caller takes the lock).
set -u
here=$(cd "$(dirname "$0")" && pwd)
corpus=$1 set=$2 way=$3 label=$4 tree=$5
record=$here/../672-rest-claude/scratch
mapfile -t names < "$record/$corpus-names.txt"
units=("${names[@]/#/$record/$corpus-$set/}"); units=("${units[@]/%/.i}")
options=()
if [ "$corpus" = musl ]; then options=(-std=c99 -nostdinc -ffreestanding); fi
mkdir -p "$here/results" "$here/scratch/g"
rm -rf "$here/scratch/g"; mkdir -p "$here/scratch/g"
(cd "$here/scratch/g" && BUSTER_PROBE_PHASES=1 setarch -R taskset -c 2 "$here/$tree/build/compiler" "${options[@]}" --attested="$way" --time-stages --lanes 1 -c "${units[@]}" 2>&1 > /dev/null |
    grep -E '^PROBE|^attested declarations' | grep -v '^$' > "$here/results/gone-$corpus-$set-$way-$label.raw")
{ grep '^PROBE' "$here/results/gone-$corpus-$set-$way-$label.raw" | tail -1; grep '^attested declarations' "$here/results/gone-$corpus-$set-$way-$label.raw"; } > "$here/results/gone-$corpus-$set-$way-$label.txt"
rm -f "$here/results/gone-$corpus-$set-$way-$label.raw"
rm -rf "$here/scratch/g"
cut -c1-160 "$here/results/gone-$corpus-$set-$way-$label.txt"
