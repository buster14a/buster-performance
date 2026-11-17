#!/bin/bash
# counts.sh OUT NAME=COMPILER...: each compiler's file system calls for -c of the specification's hello.c, of sqlite3.c
# and of one small musl unit (strlen.c), by strace: counts only, no timing is read from a traced run. OUT/NAME-KIND.strace
# and OUT/counts.txt: the opens, the failed ones, the asks among them (O_DIRECTORY) and the objects' comparison.
set -u
cd "$(dirname "$0")"
out=$1
shift
mkdir -p "$out"
source ../scripts/musl-common.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
: > "$out/counts.txt"
for kind in hello sqlite musl-unit; do
    for spec in "$@"; do
        name=${spec%%=*}
        c=${spec#*=}
        case $kind in
            hello) arguments=(-c inputs/hello.c) ;;
            sqlite) arguments=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c") ;;
            musl-unit) arguments=("${options[@]}" -c "$musl/src/string/strlen.c") ;;
        esac
        strace -f -e trace=openat,open,close,getdents64,fstat,newfstatat,statx,mmap,munmap,read,pread64 -o "$out/$name-$kind.strace" "$c" "${arguments[@]}" -o "/dev/shm/2873-counts-$name-$kind.o" > "$out/$name-$kind.out" 2>&1
        status=$?
        opens=$(grep -c 'openat(' "$out/$name-$kind.strace")
        failed=$(grep 'openat(' "$out/$name-$kind.strace" | grep -c ENOENT)
        asks=$(grep 'openat(' "$out/$name-$kind.strace" | grep O_DIRECTORY | grep -c ENOENT)
        present=$(grep 'openat(' "$out/$name-$kind.strace" | grep O_DIRECTORY | grep -vc ENOENT)
        echo "$kind $name: status $status; openat $opens, failed with ENOENT $failed, of them a directory asked for a component $asks; directories opened $present; sha256 $(sha256sum < "/dev/shm/2873-counts-$name-$kind.o" | cut -c1-16)" >> "$out/counts.txt"
    done
done
rm -f /dev/shm/2873-counts-*
cat "$out/counts.txt"
