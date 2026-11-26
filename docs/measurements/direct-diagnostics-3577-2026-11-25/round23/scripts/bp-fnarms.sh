#!/bin/bash
# bp-fnarms.sh: the head (eeee61ef8), eight measurement-only arms gating c_direct_cc.c's #3577 bail-ifs by enclosing
# function (not A1's), r2 (the narrow-constant fast path) and r12 (r1 and r2), built at offset 0, stripped; then one
# hold: perf stat -r 3 instructions (cycles indicative at one placement), 2 rounds.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
ARMS="head:eeee61ef8 fn-cf:ce1b4fe93 fn-ex:0c392c0a4 fn-cu:621baa948 fn-red:108ef50f4 fn-call:78ca29379 fn-init:892f7269c fn-bin:7da59df78 fn-rest:f0a824fd5 r2:e7b4db2f9 r12:9eae914d3"
cd "$D/repo" && git fetch -q "$D/fnarms.bundle" 'refs/heads/*:refs/remotes/a1parts/*' && cd "$D/work" || exit 1
git fetch -q "$D/fnarms.bundle" 'refs/heads/*:refs/remotes/a1parts/*' 2>/dev/null || true
for arm in $ARMS; do
  name=${arm%%:*}; sha=${arm##*:}
  git cat-file -e "$sha^{commit}" || { echo "missing $sha"; exit 1; }
  git checkout -q -- . 2>/dev/null; git checkout -q --detach "$sha" || exit 1
  EXCLUSIVE_TITLE="#3577 direct path: build $name" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-f-$name.log" 2>&1
  st=$?; echo "build $name status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
  cp build/compiler "$D/bins/compiler-f-$name"; strip --strip-debug "$D/bins/compiler-f-$name"; chmod +x "$D/bins/compiler-f-$name"
  "$D/bins/compiler-f-$name" --version > /dev/null || { echo "binary $name does not run"; exit 1; }
done
cd "$D" || exit 1
names=$(for arm in $ARMS; do echo -n "${arm%%:*} "; done)
EXCLUSIVE_TITLE="#3577 direct path: measure per-function arms, r2, r12" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; names=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-p.o)
  for r in 1 2; do
    for t in $names; do
      echo "== $r $t $(taskset -c 2 perf stat -r 3 -e cycles:u,instructions:u ./bins/compiler-f-$t "${flags[@]}" 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
' x "$sqlite" "$names" > fnarms.txt
cat fnarms.txt
awk '$1 == "==" { c[$3] += $4; i[$3] += $5; n[$3]++ } END { for (k in c) printf "%s %.2f M cycles %.3f M instructions\n", k, c[k] / n[k] / 1e6, i[k] / n[k] / 1e6 }' fnarms.txt | sort -k5 -n
rm -f bins/compiler-f-*
echo DONE
