#!/bin/bash
# trace-hold.sh OUT: the memory calls of two units of sqlite3.c and of six of musl's, one lane (strace; no timing).
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
out=$1
cc="$dir/trees/keep4/build/compiler"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
mkdir -p "$out/scratch"; cd "$out/scratch"
strace -f -tt -e trace=madvise,munmap,mmap,mprotect -o "$out/twice.strace" taskset -c 2 "$cc" --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" "$dir/inputs/sqlite3b.c" > /dev/null 2> "$out/twice.err"
echo "twice status $?" > "$out/status.txt"
files=$(ls "$musl"/src/string/*.c | head -6)
strace -f -tt -e trace=madvise,munmap,mmap,mprotect -o "$out/musl6.strace" taskset -c 2 "$cc" --lanes 1 -c -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" $files > /dev/null 2> "$out/musl6.err"
echo "musl6 status $?" >> "$out/status.txt"
cat /proc/sys/vm/overcommit_memory >> "$out/status.txt"
rm -f ./*.o
echo done > "$out/complete"
