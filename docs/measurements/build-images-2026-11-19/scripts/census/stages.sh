#!/usr/bin/env bash
# Sums --time-stages' stage milliseconds over musl's units compiled a process each: the originals and the reduced forms.
set -u
here=$(cd "$(dirname "$0")" && pwd)
source "$here/musl-opts.sh"
C=${COMPILER:?}
mapfile -t units < <(LC_ALL=C "$here/musl-units.sh")
mkdir -p /dev/shm/stg && cd /dev/shm/stg
for u in "${units[@]}"; do "$C" -c --lanes 1 --time-stages "${opts[@]}" "$u" 2>&1 >/dev/null | grep "^time-stage" ; done | awk -F'\t' '$2 !~ /\./ && $2 != "stage" {ms[$2]+=$3} END {for (s in ms) printf "orig\t%s\t%.1f\n", s, ms[s]}' > "$here/stages-orig.tsv"
for u in "$here"/musl-red2/*.c; do "$C" -c --lanes 1 --time-stages -std=c99 -ffreestanding -w "$u" 2>&1 >/dev/null | grep "^time-stage" ; done | awk -F'\t' '$2 !~ /\./ && $2 != "stage" {ms[$2]+=$3} END {for (s in ms) printf "red\t%s\t%.1f\n", s, ms[s]}' > "$here/stages-red.tsv"
for u in /dev/shm/empty/e*.c; do "$C" -c --lanes 1 --time-stages "${opts[@]}" "$u" 2>&1 >/dev/null | grep "^time-stage" ; done | awk -F'\t' '$2 !~ /\./ && $2 != "stage" {ms[$2]+=$3} END {for (s in ms) printf "empty\t%s\t%.1f\n", s, ms[s]}' > "$here/stages-empty.tsv"
echo done
