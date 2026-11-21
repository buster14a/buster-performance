#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
source ./corpora.sh
for name in tiles reuse passes; do
 until test -f results/"$name"/.built; do sleep 2; done
 mkdir -p "checks-tree-$name"; out="$root/checks-tree-$name"
 cc="$root/results/$name/compiler"
 clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "results/$name/build.log" | head -1)
 (cd "trees/$name" && "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$out/snippets" env BUSTER_TEST_PARSE_TREE_TILE=3 "$cc" test-parser --clang "$clang" --seed 133 >"$out/snippets.lock" 2>&1)
 echo snippets >>"$out/status"
 for page in 1 63 1024;do
  (cd "trees/$name" && "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$out/tile-$page" env BUSTER_TEST_PARSE_TREE_TILE=$page "$cc" test-parser --files-only "$root"/checks-windows/bounds/*.c >"$out/tile-$page.lock" 2>&1)
  echo "bounds-$page" >>"$out/status"
 done
 date -u +%FT%TZ >"$out/done"
done
