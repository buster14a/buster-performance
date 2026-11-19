#!/bin/bash
# #2543 on the 9700X: -c -g of the frozen sqlite3.c by main (base) and by the branch (new), one lane, on CPU 2, in turn
# (base, new) 11 rounds; per run the debug stage (--time-stages) and perf's user instructions and cycles. Then each
# object's DWARF census. Run under the lock as one run.
set -u
dir=~/buster-fast-bench/2543-claude
corpus=$dir/corpus
flags=(-w -c -g --lanes 1 --time-stages --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" -march=znver5 -std=gnu17 -nostdinc
       -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
out=$dir/results.tsv
echo "== before: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
printf 'round\ttree\tdebug_ms\tstages_ms\tinstructions\tcycles\n' > $out
for round in $(seq 1 11); do
  for tree in base new; do
    exe=$dir/$tree/build/compiler
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o $dir/perf-$tree.txt "$exe" "${flags[@]}" "$corpus/sqlite/sqlite3.c" -o $dir/obj-$tree.o 2> $dir/stages-$tree.txt
    debug=$(awk '$1=="time-stage" && $2=="debug" {print $3}' $dir/stages-$tree.txt)
    total=$(awk '$1=="time-stage" && $3 ~ /^[0-9.]+$/ && $2 !~ /\./ {t+=$3} END {printf "%.3f", t}' $dir/stages-$tree.txt)
    ins=$(awk -F, '$3 ~ /instructions/ {print $1}' $dir/perf-$tree.txt)
    cyc=$(awk -F, '$3 ~ /cycles/ {print $1}' $dir/perf-$tree.txt)
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' $round $tree $debug $total $ins $cyc >> $out
  done
done
echo "== after: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
for tree in base new; do
  o=$dir/obj-$tree.o
  echo "== $tree object: $(stat -c %s $o) bytes"
  readelf -SW $o | grep -E ' \.debug_info | \.rela\.debug_info | \.debug_rnglists | \.debug_loclists '
  readelf -rW $o | grep "Relocation section '.rela.debug_info'"
done
echo measured
