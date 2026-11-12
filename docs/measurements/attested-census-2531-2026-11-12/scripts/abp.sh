#!/bin/bash
# abp.sh NAME: instructions:u sampled by function (perf record -c 200003) of musl's -c command, NAME main or head.
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$here/../672-rest-claude/common.sh"
out=$here/results/ab
mapfile -t sources < "$here/../672-rest-claude/scratch/musl-units.txt"
name=$1
head -1 /var/lib/buster-9700x/owner >> "$out/holds.txt"
if [ "$name" = main ]; then compiler=$here/main-src/build/compiler; else compiler=$here/src/build/compiler; fi
dir=$(mktemp -d "$out/objects-XXXX")
(cd "$dir" && setarch -R taskset -c 2 perf record -q -e instructions:u -c 200003 -o "$out/perf-$name.data" -- \
    "$compiler" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2>&1; echo "record $name $?" >> "$out/status.txt")
rm -rf "$dir"
