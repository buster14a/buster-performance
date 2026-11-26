#!/bin/bash
# bp-pv256.sh: main 1e1ca2dd6 and the head eeee61ef8, each built (offset 0) with clang's default vector width for
# -march=znver5 (512: struct zeroing and copies by 64-byte stores, which forward to some later loads only when 32-byte
# aligned) and with -mprefer-vector-width=256 (32-byte stores); each build under its own hold, stripped; then one hold:
# perf stat -r 5 cycles, instructions, refused forwards (ls_bad_status2.stli_other), 3 rounds in rotation.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
for arm in main-d:1e1ca2dd6:0 main-v:1e1ca2dd6:256 head-d:eeee61ef8:0 head-v:eeee61ef8:256; do
  IFS=: read -r name sha width <<< "$arm"
  defs="-DBUSTER_CHECKER_OFFSET=0"; [ "$width" = 256 ] && defs="-mprefer-vector-width=256 -DBUSTER_CHECKER_OFFSET=0"
  git checkout -q -- . 2>/dev/null; git checkout -q --detach "$sha" || exit 1
  EXCLUSIVE_TITLE="#3577 direct path: build $name (vector width)" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES="$defs" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-pv-$name.log" 2>&1
  st=$?; echo "build $name status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
  cp build/compiler "$D/bins/compiler-pv-$name"; strip --strip-debug "$D/bins/compiler-pv-$name"; chmod +x "$D/bins/compiler-pv-$name"
  "$D/bins/compiler-pv-$name" --version > /dev/null || { echo "binary $name does not run"; exit 1; }
done
cd "$D" || exit 1
cmp -s <(./bins/compiler-pv-head-d -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/stdout) <(./bins/compiler-pv-head-v -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/stdout) && echo "head objects identical" || echo "head objects DIFFER"
EXCLUSIVE_TITLE="#3577 direct path: measure vector width" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-v.o)
  for r in 1 2 3; do
    for t in main-d main-v head-d head-v; do
      echo "== $r $t $(taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u,ls_bad_status2.stli_other:u ./bins/compiler-pv-$t "${flags[@]}" 2>&1 | grep -E "cycles|instructions|stli" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
' x "$sqlite" > pv256.txt
cat pv256.txt
awk '$1 == "==" && $2 > 1 { c[$3] += $4; i[$3] += $5; s[$3] += $6; n[$3]++ } END { for (k in c) printf "%s %.2f M cycles %.3f M instructions %.0f K refused forwards\n", k, c[k] / n[k] / 1e6, i[k] / n[k] / 1e6, s[k] / n[k] / 1e3 }' pv256.txt | sort
rm -f bins/compiler-pv-*
echo DONE
