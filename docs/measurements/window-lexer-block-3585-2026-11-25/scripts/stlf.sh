#!/bin/bash
# stlf.sh NAME FUNC...: bin/direct-NAME's forwarding failures (20 compiles, CPU 2) by function and by instruction in
# each FUNC. One hold.
set -uo pipefail
. "$(dirname "$0")/env.sh"
name=$1; shift
out=$here/results/$name; mkdir -p "$out"
obj=/dev/shm/3585-claude-$name.s.o
taskset -c 2 perf record -q -e ls_bad_status2.stli_other:u -c 23 -o "$out/s.data" -- "$here/bin/direct-$name" "${hargs[@]}" -o "$obj" --repeat 20 > /dev/null 2>&1
perf report -i "$out/s.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^$' | grep -v '^#' | head -30 > "$out/s.functions.txt"
for f in "$@"; do perf annotate -i "$out/s.data" --stdio -l -s "$f" 2> /dev/null > "$out/s.$f.txt"; done
rm -f "$out/s.data" "$obj"
cd "$here/results" && tar cf - "$name" | zstd -q -3 > "$here/results/$name.s.tar.zst"
