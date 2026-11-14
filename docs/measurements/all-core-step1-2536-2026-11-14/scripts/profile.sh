#!/bin/bash
# profile.sh COMPILER OUT OPTIONS...: cycles:u by symbol of sqlite3.c's -c on CPU 2, alone, then beside seven workers
# (CPUs 0, 1, 3 to 7) compiling the same in a loop. Run inside one hold of the lock.
set -u
compiler=$1 out=$2
shift 2
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p "$out"
command=("$compiler" --lanes 1 "$@" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
perf record -q -e cycles:u -c 50021 -o "$out/one.data" -- taskset -c 2 bash -c 'for i in 1 2 3 4 5 6; do "$@" -o /dev/null; done' _ "${command[@]}" 2> "$out/one.log"
pids=()
touch "$out/run.flag"
for cpu in 0 1 3 4 5 6 7; do
    taskset -c $cpu bash -c 'end=$((SECONDS + 30)); while [ -e "$1" ] && [ $SECONDS -lt $end ]; do shift_args=("${@:2}"); "${shift_args[@]}" -o /dev/null; done' _ "$out/run.flag" "${command[@]}" &
    pids+=($!)
done
sleep 0.3
perf record -q -e cycles:u -c 50021 -o "$out/eight.data" -- taskset -c 2 bash -c 'for i in 1 2 3 4 5 6; do "$@" -o /dev/null; done' _ "${command[@]}" 2> "$out/eight.log"
rm -f "$out/run.flag"
wait "${pids[@]}"
for c in one eight; do
    perf report -q -i "$out/$c.data" --no-children --sort symbol --percent-limit 0.05 -F overhead,period,symbol 2> /dev/null > "$out/$c.symbols.txt"
done
