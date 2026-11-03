#!/bin/bash
# usage: iprof-remote.sh TREE TAG CONFIG: perf record of retired instructions with the print repeated (local harness)
tree="$1"; tag="$2"; config="$3"
cd ~/buster-fast-bench/649-claude/"$tree" || exit 1
out=~/buster-fast-bench/649-claude/out/"$tag"
mkdir -p "$out"
src=~/buster-fast-bench/649-claude/base/src
markers=""; [[ $config == *E ]] && markers="--markers"
EXCLUSIVE_OWNER=claude-649 EXCLUSIVE_TITLE="solve 649 instruction profile" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/649" \
  ~/buster-fast-bench/exclusive.sh bash -c "BUSTER_PP_PRINT_REPEAT=4 taskset -c 2 perf record -e instructions:u -c 200003 -o $out/perf.data ./build/compiler benchmark-preprocessor --only vectorized $markers -target x86_64-pc-linux-gnu -march=native -I$src -fwrapv -funsigned-char $src/buster/compiler/main.c > $out/bench.txt 2>&1;
perf report -i $out/perf.data --no-children --sort sym --stdio 2>/dev/null | grep -v '^#' | grep -v '^\$' | head -20 > $out/report.txt;
perf annotate -i $out/perf.data --stdio -s pp_print 2>/dev/null > $out/print.txt;
perf annotate -i $out/perf.data --stdio -s pp_print_spellings 2>/dev/null > $out/spellings.txt"
echo done > "$out/done"
