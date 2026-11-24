#!/bin/bash
# run.sh: forwarding latency and failures by store width, load width and offset on this CPU (one hold).
cd "$(dirname "$0")"
printf '%-6s %-5s %-6s %10s %10s\n' store load offset cycles/it stlfail/it
row() {
    out=$(taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,ls_bad_status2.stli_other:u -- ./stlf "$1" "$2" "$3" 20000000 2>&1 > /dev/null)
    c=$(echo "$out" | awk -F';' '$3 ~ /cycles/ {printf "%.2f", $1/20000000}')
    s=$(echo "$out" | awk -F';' '$3 ~ /stli/ {printf "%.3f", $1/20000000}')
    printf '%-6s %-5s %-6s %10s %10s\n' "$1" "$2" "$3" "$c" "$s"
}
for l in 1 4 8; do for o in 0 1 4 8 12 16 24 28 32 36 48 56 60; do [ $((o + l)) -le 64 ] && row 64 $l $o; done; done
for o in 0 16 32 48; do row 64 16 $o; done; row 64 16 8; row 64 16 40
for o in 0 32 16; do row 64 32 $o; done
row 64 64 0
for l in 1 4 8; do for o in 0 4 8 16 24 28; do [ $((o + l)) -le 32 ] && row 32 $l $o; done; done
row 32 16 0; row 32 16 16; row 32 16 8; row 32 32 0
for l in 1 4 8; do for o in 0 4 8; do [ $((o + l)) -le 16 ] && row 16 $l $o; done; done
row 8 8 0; row 8 4 0; row 8 4 4; row 8 1 0; row 8 1 5; row 4 4 0; row 4 1 2; row 1 1 0
# Fields stored one at a time, then loads of each width over them.
row 0 4 0; row 0 1 4; row 0 8 0; row 0 8 8; row 0 16 0; row 0 32 0; row 0 32 8; row 0 8 16; row 0 16 24; row 0 64 0
