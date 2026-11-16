#!/bin/bash
# maps.sh: one compile of sqlite3.c by the census tree under strace -f -k, as cpuwide.sh runs it (CPU 2, no address-space
# randomization, waitall, --time-stages), for each mapping's call stack: the compile maps the same addresses in the same
# order each time, so a recording's mapping is named by the stack that mapped it here. In one hold of the lock
# (lock.sh ./maps.sh). Then the compiler's frames are named with addr2line (functions and lines, inlined frames too).
set -u
cd "$(dirname "$0")"
here=$PWD
out=results/maps
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
compiler=$here/census/build/compiler
status=0
strace -f -k -e trace=mmap,munmap,mremap,mprotect,madvise,brk -o "$out/strace.txt" taskset -c 2 setarch -R tools/waitall "$compiler" --time-stages -c \
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-maps.o \
    2> "$out/stages.txt" > /dev/null || status=1
# The compiler's frames: `> /path/compiler(+0x...) [0x...]` or `> /path/compiler(symbol+0x...) [0x...]`; their offsets.
grep -o -E "compiler\([^)]*\) \[0x[0-9a-f]+\]" "$out/strace.txt" | grep -o -E "\[0x[0-9a-f]+\]" | tr -d '[]' | sort -u > "$out/offsets.txt"
addr2line -i -f -C -e "$compiler" < "$out/offsets.txt" > "$out/offsets-lines.txt" 2>&1 || status=1
# One line an address with its inlined frames joined: OFFSET<TAB>function (file:line) <- caller (file:line) ...
llvm-symbolizer --obj="$compiler" --inlining --relative-address --output-style=GNU < "$out/offsets.txt" > "$out/offsets-symbolized.txt" 2>&1 || true
rm -f /dev/shm/2873-maps.o
exit $status
