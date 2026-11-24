#!/bin/bash
# run2.sh: forwarding from a store that crosses a cache line (the buffer's start moved by MISALIGN bytes).
cd "$(dirname "$0")"
printf '%-6s %-5s %-6s %-8s %10s %10s\n' store load offset misalign cycles/it stlfail/it
row() {
    out=$(taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,ls_bad_status2.stli_other:u -- ./stlf "$1" "$2" "$3" 20000000 "$4" 2>&1 > /dev/null)
    c=$(echo "$out" | awk -F';' '$3 ~ /cycles/ {printf "%.2f", $1/20000000}')
    s=$(echo "$out" | awk -F';' '$3 ~ /stli/ {printf "%.3f", $1/20000000}')
    printf '%-6s %-5s %-6s %-8s %10s %10s\n' "$1" "$2" "$3" "$4" "$c" "$s"
}
# A 64-byte store at +20: bytes 0..43 in the first line, 44..63 in the second.
for l in 1 4; do for o in 0 4 8 16 24 28 32 36 40 44 48 56 60; do row 64 $l $o 20; done; done
for o in 0 8 16 24 32 40 48 56; do row 64 8 $o 20; done
# At +4 (60 bytes in the first line) and +60 (4 in the first).
for o in 0 28 32 56 60; do row 64 4 $o 4; done
for o in 0 4 8 28 32 60; do row 64 4 $o 60; done
# At +32: each half in its own line.
for o in 0 28 32 60; do row 64 4 $o 32; done
# A 32-byte store that crosses the line (+44: 20 bytes in the first), and one that does not (+20).
for o in 0 8 16 20 24 28; do row 32 4 $o 44; done
for o in 0 16 28; do row 32 4 $o 20; done
for o in 0 16 24; do row 32 8 $o 44; done
row 32 32 0 44; row 64 64 0 20; row 16 16 0 56; row 16 4 4 56; row 16 4 12 56; row 8 8 0 60; row 8 4 4 60; row 8 4 0 60
