#!/bin/bash
# The 9700X job's own build of main's head, and its sqlite3.c compile's instructions against the stated baseline. One hold.
set -u
cd ~/buster-fast-bench/2850-claude-vjgaob/buster
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
rev=$(git rev-parse --short=9 HEAD)
out=../results/main-count-$rev
mkdir -p "$out"
{ date -u; cat /proc/loadavg; } > "$out/before.txt"
start=$(date +%s)
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$out/build.log" 2>&1; echo "build-status=$? seconds=$(( $(date +%s) - start ))" >> "$out/build.log"
C=$(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-output --config Release 2>/dev/null)
echo "compiler=$C" >> "$out/build.log"
cp "$C" "build/compiler-job-$rev" && chmod +x "build/compiler-job-$rev"
O=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
taskset -c 2 "build/compiler-job-$rev" measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${O[@]}" > "$out/measure.txt" 2>&1; echo "status=$?" >> "$out/measure.txt"
taskset -c 2 "build/compiler-job-$rev" "${O[@]}" -o "$out/sqlite3.o" 2> "$out/compile.err"; echo "status=$?" >> "$out/compile.err"
sha256sum "$out/sqlite3.o" > "$out/object.sha256"
{ date -u; cat /proc/loadavg; } > "$out/after.txt"
echo done > "$out/complete"
