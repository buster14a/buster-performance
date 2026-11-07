#!/bin/bash
# usage: prof.sh TREE LABEL: build TREE (znver5, debug info), then measure-compile --time-stages, and perf record of
# five compiles with its reports by symbol and by source line, each under its own hold of the 9700X's lock, into
# out-LABEL. #1671's coded walk.
set -u
base=~/buster-fast-bench/1671-claude-coded
tree="$1"; label="$2"
out="$base/out-$label"; mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-1671-coded EXCLUSIVE_TITLE="#1671: the expressions' coded walk" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1671
ex=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
cd "$base/$tree"
git log -1 --format=%H > "$out/revision"
BUSTER_HOST_ARCH=znver5 $ex ./build.sh > "$out/build.log" 2>&1 || { echo build failed; exit 1; }
cp build/compiler "$out/compiler"
sha256sum "$out/compiler" > "$out/compiler.sha"
$ex taskset -c 2 "$out/compiler" measure-compile --runs 11 -- "${options[@]}" > "$out/measure.txt" 2>&1
$ex taskset -c 2 perf record -q -F 20000 -o "$out/perf.data" -- \
  bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile "$out/compiler" "${options[@]}" -o "$out/sqlite3.o"
perf report -i "$out/perf.data" --stdio --no-children --sort symbol --percent-limit 0.1 > "$out/symbol.txt" 2>/dev/null
perf script -i "$out/perf.data" -F ip,sym,symoff,dso > "$out/samples.txt" 2>/dev/null
sha256sum "$out/sqlite3.o" > "$out/object.sha"
echo done > "$out/DONE"
