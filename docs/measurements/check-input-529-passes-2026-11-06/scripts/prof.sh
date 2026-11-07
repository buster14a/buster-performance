#!/bin/bash
# usage: prof.sh TREE LABEL   (in ~/buster-fast-bench/529-claude-galileo)
set -u
base=~/buster-fast-bench/529-claude-galileo
tree="$1"; label="$2"
out="$base/out-$label"; mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-529-galileo EXCLUSIVE_TITLE="#529 check-input profile" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/529
ex=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
cd "$base/$tree"
if [ "${SKIP_BUILD:-0}" != 1 ]; then
  BUSTER_HOST_ARCH=znver5 $ex ./build.sh > "$out/build.log" 2>&1 || { echo build failed; exit 1; }
fi
cp build/compiler "$out/compiler"
$ex taskset -c 2 "$out/compiler" measure-compile --runs 11 -- "${options[@]}" > "$out/measure.txt" 2>&1
$ex taskset -c 2 perf record -q -F 20000 -o "$out/perf.data" -- \
  bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile "$out/compiler" "${options[@]}" -o "$out/sqlite3.o"
perf report -i "$out/perf.data" --stdio --no-children --sort symbol --percent-limit 0.1 > "$out/symbol.txt" 2>/dev/null
"$out/compiler" "${options[@]}" -o "$out/sqlite3.o"
sha256sum "$out/sqlite3.o" > "$out/object.sha"
echo done > "$out/DONE"
