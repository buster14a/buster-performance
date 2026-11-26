#!/bin/bash
# bp-ablgrp.sh: the head (eeee61ef8) and three measurement-only arms that each gate one file's #3577 bail-ifs behind
# an opaque never-true test (abl22-lex f0f49826a, abl22-types c5011be65, abl22-cc 474e80dcc), built at offset 0 under
# their own holds; then one hold: perf stat -r 5 cycles and instructions, 3 rounds. sqlite3.c's object is the head's.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" && git fetch -q "$D/ablgrp.bundle" abl22-lex abl22-types abl22-cc && cd "$D/work" || exit 1
git fetch -q "$D/ablgrp.bundle" abl22-lex abl22-types abl22-cc 2>/dev/null || true
git cat-file -e f0f49826a^{commit} && git cat-file -e c5011be65^{commit} && git cat-file -e 474e80dcc^{commit} || { echo "missing commits"; exit 1; }
for arm in head:eeee61ef8 lex:f0f49826a types:c5011be65 cc:474e80dcc; do
  name=${arm%%:*}; sha=${arm##*:}
  git checkout -q -- . 2>/dev/null; git checkout -q --detach "$sha" || exit 1
  EXCLUSIVE_TITLE="#3577 direct path: build $name (per-file ablation)" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-g-$name.log" 2>&1
  st=$?; echo "build $name status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
  cp build/compiler "$D/bins/compiler-g-$name"; strip --strip-debug "$D/bins/compiler-g-$name"; chmod +x "$D/bins/compiler-g-$name"
  "$D/bins/compiler-g-$name" --version > /dev/null || { echo "binary $name does not run"; exit 1; }
done
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: measure per-file ablation" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-g.o)
  for r in 1 2 3; do
    for t in head lex types cc; do
      echo "== $r $t $(taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u ./bins/compiler-g-$t "${flags[@]}" 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
' x "$sqlite" > ablgrp.txt
cat ablgrp.txt
awk '$1 == "==" && $2 > 1 { c[$3] += $4; i[$3] += $5; n[$3]++ } END { for (k in c) printf "%s %.2f M cycles %.3f M instructions\n", k, c[k] / n[k] / 1e6, i[k] / n[k] / 1e6 }' ablgrp.txt | sort
rm -f bins/compiler-g-*
echo DONE
