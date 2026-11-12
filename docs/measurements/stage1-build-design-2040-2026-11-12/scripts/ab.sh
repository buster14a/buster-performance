#!/bin/bash
# One time-runs comparison of builds over their placements, to be run inside the 9700X lock (lock.sh), pinned to CPU 2,
# as the 9700X workflow compares a pull request with its base (#1050's measure):
#   ab.sh NAME LIST RUNS COPIES BUILD=DIRECTORY...
# Each DIRECTORY holds a build's placements, compiler-0, compiler-1088, compiler-2112 and compiler-3136, which
# `./build.sh shifts DIRECTORY main_unit_checker.c 0 1088 2112 3136` made. LIST is the workload:
#   sqlite   -c of the frozen sqlite3.c with measure-compile's options
#   syntax   -fsyntax-only of the compiler's own checker unit
#   smoke    test-lexer (the vector lexer's tests: the driver unit's own code)
# The base build's compiler runs time-runs. The report goes to results/ab/NAME.txt.
set -u
export LC_ALL=C
name=$1; list=$2; runs=$3; copies=$4
shift 4
d=$HOME/buster-fast-bench/2040-claude
mkdir -p "$d/results/ab" "$d/scratch/ab"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
case $list in
    sqlite)
        printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check --quiet || exit 2
        options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$d/scratch/ab/$name.o") ;;
    syntax) options=(-fsyntax-only -march=native "-I$d/src/src" -fwrapv -funsigned-char "$d/src/src/buster/compiler/main_unit_checker.c") ;;
    smoke) options=(test-lexer) ;;
    *) echo "unknown list $list" >&2; exit 2 ;;
esac
builds=()
for build in "$@"; do
    for shift in 0 1088 2112 3136; do
        [ -x "${build#*=}/compiler-$shift" ] || { echo "missing ${build#*=}/compiler-$shift" >&2; exit 2; }
        builds+=(--build "${build%%=*}" "${build#*=}/compiler-$shift")
    done
done
head -1 /var/lib/buster-9700x/owner > "$d/results/ab/$name.holder.txt"
copy=()
[ "$copies" = 0 ] || copy=(--copies "$copies")
cd "$d/scratch/ab" || exit 2
TIMEFORMAT='%R s wall for the comparison'
{ time taskset -c 2 "$d/placements/base/compiler-0" time-runs --runs "$runs" "${copy[@]}" "${builds[@]}" --list "${options[@]}" > "$d/results/ab/$name.txt" 2>&1; } 2> "$d/results/ab/$name.time.txt"
echo "status $?" >> "$d/results/ab/$name.time.txt"
echo "$name: $(tail -3 "$d/results/ab/$name.txt" | tr '\n' ' ' | cut -c1-300)" >> "$d/results/ab.txt"
