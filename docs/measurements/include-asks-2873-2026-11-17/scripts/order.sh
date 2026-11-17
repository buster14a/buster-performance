#!/bin/bash
# order.sh TREE OUT WHAT [FROM TO]: the start order's inputs from TREE's own executable and tools, in OUT. WHAT is
# `small` (compiler start-trace of an empty file's -fsyntax-only and -E -P, tiny.c's -c and hello.c's -c, into
# syntax.txt, preprocess.txt, tiny.txt and hello.txt, and the executable's `readelf -sW` into symbols.txt), `sqlite`
# (-c sqlite3.c, the census's options, into sqlite.txt), `musl` (musl's units FROM to TO, a process each, appended to
# musl.txt) or `list` (compiler start-order of them all, into body.txt). Each traced command's status is checked. One
# hold of the lock a call.
set -u
cd "$(dirname "$0")"
here=$PWD
tree=$1
out=$2
what=$3
mkdir -p "$out"
compiler=$here/$tree/build/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
status=0
trace() { local name=$1; shift; taskset -c 2 "$compiler" start-trace "$out/$name.txt" "$@" > /dev/null 2>> "$out/$name.err" || { status=1; echo "failed: $*" >> "$out/$name.err"; }; }
case $what in
    small)
        rm -f "$out"/{syntax,preprocess,tiny,hello}.{txt,err}
        readelf -sW "$compiler" > "$out/symbols.txt"
        sha256sum "$compiler" > "$out/compiler.sha256"
        trace syntax "$compiler" -fsyntax-only order-inputs/empty.c
        trace preprocess "$compiler" -E -P order-inputs/empty.c
        trace tiny "$compiler" -c order-inputs/tiny.c -o /dev/shm/2873-p1.o
        trace hello "$compiler" -c order-inputs/hello.c -o /dev/shm/2873-p1.o ;;
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
    list)
        "$compiler" start-order "$out/symbols.txt" "$out/syntax.txt" "$out/preprocess.txt" "$out/tiny.txt" "$out/hello.txt" "$out/musl.txt" "$out/sqlite.txt" > "$out/body.txt" || status=1
        for f in syntax preprocess tiny hello musl sqlite; do echo "$f: $(grep -c '^trace$' "$out/$f.txt") traces, $(grep -vc '^trace$' "$out/$f.txt") addresses"; done > "$out/counts.txt"
        head -1 "$out/body.txt" >> "$out/counts.txt" ;;
esac
rm -f /dev/shm/2873-p1.o
exit $status
