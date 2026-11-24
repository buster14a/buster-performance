#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.
# Two Release executables, waitall, peakrss, frozen SQLite directory, new output directory.
set -euo pipefail
if [[ $# -ne 6 ]]; then
    echo "usage: $0 BASE HEAD WAITALL PEAKRSS SQLITE_DIRECTORY OUTPUT_DIRECTORY" >&2
    exit 2
fi
base=$(realpath "$1")
head=$(realpath "$2")
waitall=$(realpath "$3")
peakrss=$(realpath "$4")
sqlite=$(realpath "$5")
lock=$(realpath "$(dirname "$0")/locked.sh")
mkdir "$6"
out=$(realpath "$6")
cp "$base" "$out/base.compiler"
cp "$head" "$out/head.compiler"
sha256sum "$out/"*.compiler >"$out/executables.sha256"
scratch=$(mktemp -d /dev/shm/buster-1167.XXXXXXXX)
trap 'rm -f "$scratch/base.o" "$scratch/head.o"; rmdir "$scratch"' EXIT
args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
export BUSTER_HUGE_PAGES=1
for ((r=0;r<12;r++)); do
    order=(base head)
    if ((r%2)); then order=(head base); fi
    for rev in "${order[@]}"; do
        "$lock" timeout -k 5 45 perf stat -C 2 -x, -e cycles:k,cycles:u,page-faults -o "$out/$rev-$r.csv" -- \
            taskset -c 2 "$waitall" "$peakrss" "$out/peak.txt" "$r-$rev" "$out/$rev.compiler" "${args[@]}" -o "$scratch/$rev.o" \
            >>"$out/holds.log" 2>&1
    done
    cmp "$scratch/base.o" "$scratch/head.o"
    sha256sum "$scratch/base.o" >>"$out/objects.sha256"
done
