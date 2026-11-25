#!/bin/bash
# ceil.sh: the predefines' cost in a fresh process on CPU 2, an empty unit (int x;) by compiler-dead2 (main f74b0b28 with
# step 6d): the driver's own predefines, the same 414 macros from a file, the 76 outside pp_predefines_base, and none.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
d=$here/step2
C=$here/bin/compiler-dead2
"$C" --version > /dev/null || exit 1
out=$d/ceil.txt
: > "$out"
for r in 1 2 3 4 5; do
  for mode in default full tail none; do
    case $mode in
      default) args=();;
      full) args=(--predefines "$d/full.h");;
      tail) args=(--predefines "$d/tail.h");;
      none) args=(--predefines "$d/none.h");;
    esac
    perf stat -x, -e instructions:u,cycles:u,cycles:k,page-faults -r 200 -o "$d/ps.tmp" -- taskset -c 2 "$C" "${args[@]}" -c "$d/empty.c" -o /dev/shm/s2-np4nn5.o
    echo "$mode $r $(grep -v '^#' "$d/ps.tmp" | grep -v '^$' | awk -F, '{printf "%s=%s ", $3, $1}')" >> "$out"
  done
done
readelf -p .comment /dev/shm/s2-np4nn5.o | grep -o 'buster[^ ]*' | head -1 >> "$out"
cat "$out"
