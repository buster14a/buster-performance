#!/bin/bash
# libc-callers.sh LABEL [BYTES]: who calls libc's memset, memmove (memcpy, mempcpy) and memcmp with BYTES or more
# (default 1024) in -c sqlite3.c, by the bytes asked for. A sample in one of these functions whose 16 last branches are
# all the copy's own loop has no caller in its branch stack (brips.c's way 2); this says whose bytes those are.
# gdb on a stripped copy of results/LABEL/compiler, a conditional breakpoint at each function's entry that prints the
# size and the return address; the addresses are named with their inline chains from the unstripped executable.
# One hold of the lock (gdb stops at every call: a minute or more). results/LABEL/libc-callers.txt, and the calls
# themselves in results/LABEL/libc-calls.txt (KIND BYTES RETURN-ADDRESS).
set -u
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; least=${2:-1024}
c=results/$label/compiler
strip -o scratch/compiler.stripped "$c"
entry()
{
    nm "$c" | awk -v name="$1" '$3 == name { print $1; exit }'
}
{
    echo "set pagination off"
    echo "set confirm off"
    for pair in S:__memset_avx512_unaligned_erms M:__memmove_avx512_unaligned_erms P:__mempcpy_avx512_unaligned_erms C:__memcmp_evex_movbe; do
        kind=${pair%%:*}; address=$(entry "${pair#*:}")
        [ -n "$address" ] || { echo "no symbol ${pair#*:}" >&2; exit 1; }
        echo "break *0x$address if \$rdx >= $least"
        echo "commands"
        echo "silent"
        echo "printf \"$kind %lu %lx\\n\", \$rdx, *(unsigned long*)\$rsp"
        echo "continue"
        echo "end"
    done
    echo "run"
} > scratch/libc-callers.gdb
eval "./lock.sh timeout -k 5 420 gdb -nx -q -batch -x scratch/libc-callers.gdb --args scratch/compiler.stripped -c $(corpus_options sqlite3) $sqlite/sqlite3.c -o /dev/shm/claude-2874.o" > scratch/libc-callers.out 2>&1
status=$?
rm -f /dev/shm/claude-2874.o
grep -E '^[SMPC] [0-9]+ [0-9a-f]+$' scratch/libc-callers.out > "results/$label/libc-calls.txt"
awk '{ k = $1 " " $3; bytes[k] += $2; calls[k] += 1 } END { for (k in bytes) print k, bytes[k], calls[k] }' "results/$label/libc-calls.txt" | sort -k1,1 -k3,3nr > scratch/libc-callers.sums
awk '{ print "0x" $2 }' scratch/libc-callers.sums | llvm-symbolizer -p -i -s --no-demangle --obj="$c" | awk 'BEGIN { RS = "" } { gsub(/\n \(inlined by\) /, " < "); gsub(/\n/, " "); gsub(/ at [^ ]+/, ""); print }' > scratch/libc-callers.names
{
    echo "gdb status $status; calls of $least bytes or more in -c sqlite3.c: S memset, M memmove and memcpy, P mempcpy, C memcmp"
    awk '{ bytes[$1] += $2; calls[$1] += 1; if ($2 >= 4096) { big[$1] += $2; bigcalls[$1] += 1 } } END { for (k in bytes) printf "%s: %d calls, %d bytes; of 4096 bytes or more %d calls, %d bytes\n", k, calls[k], bytes[k], bigcalls[k], big[k] }' "results/$label/libc-calls.txt" | sort
    echo "KIND BYTES CALLS RETURN-ADDRESS the caller's inline chain, innermost first"
    paste -d' ' <(awk '{ print $1, $3, $4, $2 }' scratch/libc-callers.sums) scratch/libc-callers.names
} > "results/$label/libc-callers.txt"
head -6 "results/$label/libc-callers.txt"
