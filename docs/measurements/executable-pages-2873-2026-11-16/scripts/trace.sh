#!/bin/bash
# trace.sh OUT COMPILER WHAT [FROM TO]: the functions each command runs, exactly (tools/starttrace: a breakpoint at
# every function's entry, removed as it is hit), in OUT/WHAT.txt, a trace a command. WHAT is `small` (an empty file's
# -fsyntax-only and -E -P, tiny.c's -c and hello.c's -c, into syntax.txt, preprocess.txt, tiny.txt and hello.txt),
# `sqlite` (-c sqlite3.c, the census's options) or `musl` (musl's units FROM to TO, each a process, appended to
# musl.txt). OUT/symbols.txt is the executable's `readelf -sW`. One hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
out=$1
compiler=$2
what=$3
mkdir -p "$out"
[ -f "$out/symbols.txt" ] || readelf -sW "$compiler" > "$out/symbols.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
trace() { local name=$1; shift; taskset -c 2 tools/starttrace "$out/symbols.txt" "$out/$name.txt" "$@" 2>> "$out/$name.err" > /dev/null; }
case $what in
    small)
        rm -f "$out"/{syntax,preprocess,tiny,hello}.{txt,err}
        trace syntax "$compiler" -fsyntax-only inputs/empty.c
        trace preprocess "$compiler" -E -P inputs/empty.c
        trace tiny "$compiler" -c inputs/tiny.c -o /dev/shm/2873-p1.o
        trace hello "$compiler" -c inputs/hello.c -o /dev/shm/2873-p1.o ;;
    sqlite)
        rm -f "$out"/sqlite.{txt,err}
        trace sqlite "$compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-p1.o ;;
    musl)
        source ../scripts/musl-common.sh
        from=$4
        to=$5
        [ "$from" = 0 ] && rm -f "$out"/musl.{txt,err}
        for ((i = from; i < to && i < ${#files[@]}; i += 1)); do
            trace musl "$compiler" "${options[@]}" -c "${files[$i]}" -o /dev/shm/2873-p1.o
        done ;;
esac
rm -f /dev/shm/2873-p1.o
