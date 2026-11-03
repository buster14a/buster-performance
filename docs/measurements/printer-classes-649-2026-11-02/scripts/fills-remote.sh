#!/bin/bash
# usage: fills-remote.sh TREE TAG: demand fills by source (L2, L3, DRAM) per symbol, -P printing on main.c
tree="$1"; tag="$2"
cd ~/buster-fast-bench/649-claude/"$tree" || exit 1
out=~/buster-fast-bench/649-claude/out/"$tag"
mkdir -p "$out"
src=~/buster-fast-bench/649-claude/base/src
EXCLUSIVE_OWNER=claude-649 EXCLUSIVE_TITLE="solve 649 fills" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/649" \
  ~/buster-fast-bench/exclusive.sh bash -c "
for ev in ls_dmnd_fills_from_sys.local_l2 ls_dmnd_fills_from_sys.local_ccx ls_dmnd_fills_from_sys.dram_io_all; do
  taskset -c 2 perf record -e \$ev:u -c 2003 -o $out/\$ev.data ./build/compiler benchmark-preprocessor --only vectorized -target x86_64-pc-linux-gnu -march=native -I$src -fwrapv -funsigned-char $src/buster/compiler/main.c > $out/\$ev.bench.txt 2>&1
  perf report -i $out/\$ev.data --no-children --sort sym --stdio 2>/dev/null | grep -v '^#' | grep -v '^\$' | head -14 > $out/\$ev.report.txt
  perf annotate -i $out/\$ev.data --stdio -s pp_print 2>/dev/null > $out/\$ev.print.txt
  perf annotate -i $out/\$ev.data --stdio -s pp_print_spellings 2>/dev/null > $out/\$ev.spellings.txt
  perf report -i $out/\$ev.data --stdio --sort sym 2>/dev/null | grep -m1 'Event count' > $out/\$ev.count.txt
done"
echo done > "$out/done"
