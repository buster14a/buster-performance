#!/bin/bash
# usage: profile-remote.sh TREE TAG [extra benchmark args...]  (on benchpress): perf record of -P printing on main.c
tree="$1"; tag="$2"; shift 2
cd ~/buster-fast-bench/649-claude/"$tree" || exit 1
out=~/buster-fast-bench/649-claude/out/"$tag"
mkdir -p "$out"
EXCLUSIVE_OWNER=claude-649 EXCLUSIVE_TITLE="solve 649 (-P compaction)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/649" \
  ~/buster-fast-bench/exclusive.sh bash -c "taskset -c 2 perf record -e cycles:u -c 200003 -o $out/perf.data ./build/compiler benchmark-preprocessor --only vectorized $* -target x86_64-pc-linux-gnu -march=native -I../base/src -fwrapv -funsigned-char ../base/src/buster/compiler/main.c > $out/bench.txt 2>&1;
perf report -i $out/perf.data --no-children --sort sym --stdio 2>/dev/null | head -60 > $out/report.txt;
perf annotate -i $out/perf.data --stdio -s pp_print_vector 2>/dev/null > $out/annotate.txt"
echo done > $out/done
