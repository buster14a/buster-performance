#!/bin/bash
# faultmap.sh OUT COMPILER KIND: every page fault of one compile by COMPILER with its address (perf's minor-faults event
# at a period of 1, with the data address), on CPU 2 under waitall, counted by the executable's sections
# (tools/faultsec). KIND is `sqlite` (-c sqlite3.c, the census's options), `empty` (an empty file's -c), or `musl` (a
# few of musl's units, each a process: the first, the 400th, the 800th and the 1,200th). OUT.txt has the tables.
set -u
cd "$(dirname "$0")"
here=$PWD
out=$1
compiler=$2
kind=$3
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
record()
{
    local name=$1
    shift
    perf record -q -o "$out-$name.data" -e 'minor-faults/period=1,call-graph=no/' -d -- taskset -c 2 ../tools/waitall "$@" 2> "$out-$name.err"
    perf script -i "$out-$name.data" -F addr 2> /dev/null > "$out-$name.addr"
    { echo "== $name: $(wc -l < "$out-$name.addr") faults"; tools/faultsec "$compiler" < "$out-$name.addr"; } >> "$out.txt"
    rm -f "$out-$name.data"
}
: > "$out.txt"
case $kind in
    sqlite)
        record sqlite "$compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-p1.o ;;
    empty)
        : > /dev/shm/2873-p1-empty.c
        record empty "$compiler" -c /dev/shm/2873-p1-empty.c -o /dev/shm/2873-p1.o ;;
    musl)
        source ../scripts/musl-common.sh
        for i in 0 400 800 1200; do
            record "musl-$i" "$compiler" "${options[@]}" -c "${files[$i]}" -o /dev/shm/2873-p1.o
        done ;;
esac
rm -f /dev/shm/2873-p1.o /dev/shm/2873-p1-empty.c
