#!/bin/bash
# ab.sh STEP: the driver hook's cost, each STEP one hold of the lock (queue.sh runs them in order), pinned to CPU 2 with
# the address-space randomization off (setarch -R):
#   main-build   main-src (main's 0af27a30, the census branch's base) built as build.sh builds src (Release, native, -g0)
#   plain NAME R -c of musl's 1,336 units as one command on one lane under perf stat, NAME main or head (ee5b39b9), round R;
#                round 1 keeps its objects
#   compare      main's round-1 objects and diagnostics against head's
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$here/../672-rest-claude/common.sh"
out=$here/results/ab
mkdir -p "$out"
mapfile -t sources < "$here/../672-rest-claude/scratch/musl-units.txt"
step=$1
head -1 /var/lib/buster-9700x/owner >> "$out/holds.txt"
case $step in
main-build)
    (cd "$here/main-src" && BUSTER_DEBUG_INFO=0 ./build.sh > "$out/main-build.log" 2>&1; echo "status $?" >> "$out/main-build.log")
    sha256sum "$here/main-src/build/compiler" "$here/src/build/compiler" > "$out/compilers.sha256"
    ;;
plain)
    name=$2; round=$3
    if [ "$name" = main ]; then compiler=$here/main-src/build/compiler; else compiler=$here/src/build/compiler; fi
    dir=$out/objects-$name-$round
    rm -rf "$dir"; mkdir -p "$dir"
    (cd "$dir" && setarch -R taskset -c 2 perf stat -x, -o "$out/stat-$name-$round.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- \
        "$compiler" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2> "$out/$name-$round.err"; echo "plain $name $round $?" >> "$out/status.txt")
    if [ "$round" != 1 ]; then rm -rf "$dir"; fi
    ;;
compare)
    same=0; different=0
    for f in "$out"/objects-main-1/*.o; do
        if cmp -s "$f" "$out/objects-head-1/${f##*/}"; then same=$((same + 1)); else different=$((different + 1)); fi
    done
    echo "objects: $same the same bytes, $different different, of $(ls "$out"/objects-main-1 | wc -l) main and $(ls "$out"/objects-head-1 | wc -l) head" > "$out/compare.txt"
    sha256sum "$out"/*.err >> "$out/compare.txt"
    rm -rf "$out"/objects-main-1 "$out"/objects-head-1
    ;;
esac
