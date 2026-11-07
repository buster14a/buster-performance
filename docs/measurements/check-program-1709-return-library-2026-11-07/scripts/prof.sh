#!/bin/bash
# usage: prof.sh TREE LABEL: build TREE (znver5), then measure-compile and perf record of five compiles of the frozen
# sqlite3.c's -c on CPU 2, each under its own hold of the lock, into out-LABEL.
set -u
. "$(dirname "$0")/common.sh"
tree="$1"; label="$2"
out="$base/out-$label"; mkdir -p "$out"
cd "$base/$tree"
git log -1 --format=%H > "$out/revision"
BUSTER_HOST_ARCH=znver5 held "$out/build.receipt" ./build.sh > "$out/build.log" 2>&1 || { echo build failed; exit 1; }
cp build/compiler "$out/compiler"
sha256sum "$out/compiler" > "$out/compiler.sha"
held "$out/measure.receipt" bash -c 'taskset -c 2 "$@" > "'"$out/measure.txt"'" 2>&1' m "$out/compiler" measure-compile --runs 11 -- "${options[@]}"
held "$out/perf.receipt" taskset -c 2 perf record -q -F 20000 -o "$out/perf.data" -- \
  bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile "$out/compiler" "${options[@]}" -o "$out/sqlite3.o"
perf report -i "$out/perf.data" --stdio --no-children --sort symbol --percent-limit 0.05 > "$out/symbol.txt" 2>/dev/null
sha256sum "$out/sqlite3.o" > "$out/object.sha"
echo done > "$out/DONE"
