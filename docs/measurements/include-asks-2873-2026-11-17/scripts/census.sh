#!/bin/bash
# census.sh COMPILER OUT: the file system calls of -c sqlite3.c and of one small musl unit's -c, by call and result, and
# the failed opens by directory (strace, counts only; no timing is read from it).
set -u
compiler=$1; out=$2
mkdir -p "$out"
cd "$(dirname "$0")"
. ./corpora.sh
unit=$musl/src/string/strlen.c
musl_options="$(printf '%q ' -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")"
trace="openat,open,stat,lstat,fstat,newfstatat,statx,access,faccessat,faccessat2,readlink,readlinkat,getdents64,read,pread64,mmap,munmap,close,write,pwrite64,lseek,ftruncate,fallocate,rename,renameat,renameat2,unlink,unlinkat"
bash -c "strace -f -e trace=$trace -o $out/sqlite.strace $compiler -c $sqlite_arguments -o /dev/shm/claude-files-census.o" > "$out/sqlite.out" 2>&1
echo "sqlite status $?" >> "$out/status.txt"
bash -c "strace -f -e trace=$trace -o $out/musl-unit.strace $compiler -c $musl_options $unit -o /dev/shm/claude-files-census.o" > "$out/musl-unit.out" 2>&1
echo "musl unit status $?" >> "$out/status.txt"
rm -f /dev/shm/claude-files-census.o
for t in sqlite musl-unit; do
    {
        echo "== $t: calls by name and result"
        sed -E 's/^[0-9]+ +//' "$out/$t.strace" | grep -E '^[a-z0-9_]+\(' | sed -E 's/^([a-z0-9_]+)\(.*\) = (-1 [A-Z]+|[0-9a-fx]+).*/\1 \2/' | sed -E 's/ [0-9a-fx]+$/ ok/' | sort | uniq -c | sort -rn
        echo "== $t: failed opens by directory"
        grep -E 'openat\(.*ENOENT' "$out/$t.strace" | sed -E 's/.*openat\([A-Z_0-9]+, "([^"]*)\/[^"\/]*".*/\1/' | sort | uniq -c | sort -rn | head -20
        echo "== $t: successful opens by directory"
        grep -E 'openat\(' "$out/$t.strace" | grep -v ENOENT | sed -E 's/.*openat\([A-Z_0-9]+, "([^"]*)\/[^"\/]*".*/\1/' | sort | uniq -c | sort -rn | head -20
    } > "$out/$t.summary.txt"
done
echo done >> "$out/status.txt"
