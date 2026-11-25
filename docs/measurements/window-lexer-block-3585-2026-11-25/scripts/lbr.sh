#!/bin/bash
# lbr.sh NAME: bin/direct-NAME's branch records (20 compiles, CPU 2): the mispredicted branches of FUNC by address,
# and first-level misses' fills by function and by address in FUNC. One hold.
set -uo pipefail
. "$(dirname "$0")/env.sh"
name=$1; func=${2:-fast_pp_lex_window}
out=$here/results/$name; mkdir -p "$out"
obj=/dev/shm/3585-claude-$name.l.o
taskset -c 2 perf record -q -j any,u -e cycles:u -c 20011 -o "$out/lbr.data" -- "$here/bin/direct-$name" "${hargs[@]}" -o "$obj" --repeat 20 > /dev/null 2>&1 || echo "lbr record failed"
perf report -i "$out/lbr.data" -b --sort symbol_from,addr_from,mispredict --no-children 2> "$out/lbr.err" | grep -v '^#' | grep -v '^$' | grep "$func" | head -80 > "$out/lbr.txt"
rm -f "$out/lbr.data"
for ev in ls_any_fills_from_sys.all:u:211 ls_dmnd_fills_from_sys.all:u:211; do
    e=${ev%:*}; c=${ev##*:}; tag=${e%%:*}
    taskset -c 2 perf record -q -e "$e" -c "$c" -o "$out/m-$tag.data" -- "$here/bin/direct-$name" "${hargs[@]}" -o "$obj" --repeat 20 > /dev/null 2>&1 || echo "record $tag failed"
    perf report -i "$out/m-$tag.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^$' | grep -v '^#' | head -20 > "$out/m-$tag.functions.txt"
    perf annotate -i "$out/m-$tag.data" --stdio --no-source -s "$func" 2> /dev/null > "$out/m-$tag.annotate.txt"
    rm -f "$out/m-$tag.data"
done
taskset -c 2 perf stat -x ';' --no-big-num -e ls_any_fills_from_sys.all:u,ls_dmnd_fills_from_sys.all:u,ls_any_fills_from_sys.dram_io_all:u,ls_any_fills_from_sys.local_l2:u -o "$out/fills.csv" -- "$here/bin/direct-$name" "${hargs[@]}" -o "$obj" --repeat 20 > /dev/null 2>&1
rm -f "$obj"
cd "$here/results" && tar cf - "$name" | zstd -q -3 > "$here/results/$name.lbr.tar.zst"
echo done
