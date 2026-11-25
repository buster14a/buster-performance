#!/bin/bash
# prof.sh NAME [FUNC]: bin/direct-NAME's samples by function and, for FUNC (fast_pp_lex_window), by instruction:
# cycles, retired instructions, mispredicted branches, forwarding failures. 60 compiles a recording, CPU 2. One hold.
set -uo pipefail
. "$(dirname "$0")/env.sh"
name=$1; func=${2:-fast_pp_lex_window}
out=$here/results/$name; mkdir -p "$out"
obj=/dev/shm/3585-claude-$name.p.o
for ev in ${EVENTS:-cycles:u:10007 ex_ret_instr:u:25013 ex_ret_brn_misp:u:101 ls_bad_status2.stli_other:u:101}; do
    e=${ev%:*}; c=${ev##*:}; tag=${e%%:*}
    taskset -c 2 perf record -q -e "$e" -c "$c" -o "$out/p-$tag.data" -- "$here/bin/direct-$name" "${hargs[@]}" -o "$obj" --repeat 60 > /dev/null 2>&1 || echo "record $tag failed: $?"
    perf report -i "$out/p-$tag.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^$' | grep -v '^#' | head -40 > "$out/p-$tag.functions.txt"
    perf annotate -i "$out/p-$tag.data" --stdio --no-source -s "$func" 2> /dev/null > "$out/p-$tag.annotate.txt"
    rm -f "$out/p-$tag.data"
done
taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,instructions:u,ex_ret_brn_misp:u,ls_bad_status2.stli_other:u,cycles:k -o "$out/stat.csv" -- "$here/bin/direct-$name" "${hargs[@]}" -o "$obj" --repeat 20 --summary > "$out/summary.txt" 2>&1
sha256sum "$obj" | cut -c1-16 >> "$out/summary.txt"
rm -f "$obj"
cd "$here/results" && tar cf - "$name" | zstd -q -3 > "$here/results/$name.tar.zst"
echo done
