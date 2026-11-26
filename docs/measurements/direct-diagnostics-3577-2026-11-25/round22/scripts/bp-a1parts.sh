#!/bin/bash
# bp-a1parts.sh: the head (eeee61ef8) and one measurement-only arm per A1 part (each part's expression-side checks behind
# an opaque test; sqlite3.c's object is the head's), built at offset 0 (incremental after the head), stripped; then one
# hold: perf stat -r 3 instructions (and cycles, indicative only at one placement), 2 rounds.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
ARMS="head:eeee61ef8 cond:60b61b1af seq:74f344126 conv:be210d5b9 binary:6ede87191 unary:e65964796 assign:fa50e6b4f prec:49dd3a868 push:eb322082e subscript:c46014bc4 end:c3de3b9f0"
cd "$D/repo" && git fetch -q "$D/a1parts.bundle" 'refs/heads/*:refs/remotes/a1parts/*' && cd "$D/work" || exit 1
git fetch -q "$D/a1parts.bundle" 'refs/heads/*:refs/remotes/a1parts/*' 2>/dev/null || true
for arm in $ARMS; do
  name=${arm%%:*}; sha=${arm##*:}
  git cat-file -e "$sha^{commit}" || { echo "missing $sha"; exit 1; }
  git checkout -q -- . 2>/dev/null; git checkout -q --detach "$sha" || exit 1
  EXCLUSIVE_TITLE="#3577 direct path: build A1 part $name" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-p-$name.log" 2>&1
  st=$?; echo "build $name status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
  cp build/compiler "$D/bins/compiler-p-$name"; strip --strip-debug "$D/bins/compiler-p-$name"; chmod +x "$D/bins/compiler-p-$name"
  "$D/bins/compiler-p-$name" --version > /dev/null || { echo "binary $name does not run"; exit 1; }
done
cd "$D" || exit 1
names=$(for arm in $ARMS; do echo -n "${arm%%:*} "; done)
EXCLUSIVE_TITLE="#3577 direct path: measure A1 parts" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; names=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-p.o)
  for r in 1 2; do
    for t in $names; do
      echo "== $r $t $(taskset -c 2 perf stat -r 3 -e cycles:u,instructions:u ./bins/compiler-p-$t "${flags[@]}" 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
' x "$sqlite" "$names" > a1parts.txt
cat a1parts.txt
awk '$1 == "==" { c[$3] += $4; i[$3] += $5; n[$3]++ } END { for (k in c) printf "%s %.2f M cycles %.3f M instructions\n", k, c[k] / n[k] / 1e6, i[k] / n[k] / 1e6 }' a1parts.txt | sort -k5 -n
rm -f bins/compiler-p-*
echo DONE
