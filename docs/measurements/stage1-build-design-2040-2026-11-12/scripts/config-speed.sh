#!/bin/bash
# The other configurations' compilers against Release's on the compile path, to be run inside the 9700X lock (lock.sh),
# pinned to CPU 2: config-speed.sh LIST RUNS NAME=EXECUTABLE...
# LIST is ab.sh's (sqlite: -c of the frozen sqlite3.c; syntax: -fsyntax-only of the checker's unit). One placement of
# each build, so a difference under about one percent is not this script's to tell (ab.sh's four placements are).
# Release's executable (the `src` clone's build/compiler) runs time-runs and is the first build. Results in
# results/config-speed-LIST.txt.
set -u
export LC_ALL=C
list=$1; runs=$2
shift 2
d=$HOME/buster-fast-bench/2040-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p "$d/scratch/config-speed"
case $list in
    sqlite) options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$d/scratch/config-speed/runs.o") ;;
    syntax) options=(-fsyntax-only -march=native "-I$d/src/src" -fwrapv -funsigned-char "$d/src/src/buster/compiler/main_unit_checker.c") ;;
    *) echo "unknown list $list" >&2; exit 2 ;;
esac
builds=(--build release "$d/src/build/compiler")
for build in "$@"; do
    [ -x "${build#*=}" ] || { echo "missing ${build#*=}" >&2; exit 2; }
    builds+=(--build "${build%%=*}" "${build#*=}")
done
head -1 /var/lib/buster-9700x/owner > "$d/results/config-speed-$list.holder.txt"
cd "$d/scratch/config-speed" || exit 2
taskset -c 2 "$d/src/build/compiler" time-runs --runs "$runs" "${builds[@]}" --list "${options[@]}" > "$d/results/config-speed-$list.txt" 2>&1
echo "status $?" >> "$d/results/config-speed-$list.txt"
