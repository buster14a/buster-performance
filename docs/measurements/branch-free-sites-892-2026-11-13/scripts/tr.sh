#!/bin/bash
# tr.sh NAME RUNS COPIES BUILD...: for #892, time-runs of -c sqlite3.c --lanes 1 by each BUILD (NAME=EXECUTABLE pairs,
# a build's placements given in the same order), from fresh copies on tmpfs, pinned to CPU 2 under the lock in one
# hold. The harness runs from a copy of its own.
set -u
base=~/buster-fast-bench/892-claude
name=${1:?name} runs=${2:?runs} copies=${3:?copies}
shift 3
cd "$base/run" || exit 2
corpus=corpus
ARGS=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17
    -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
    -isystem "$corpus/headers/usr/include"
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite" "$corpus/sqlite/sqlite3.c"
    -c -o "$base/scratch/tr-sq.o" --lanes 1)
builds=()
for pair in "$@"; do
    builds+=(--build "${pair%%=*}" "$base/bin/${pair#*=}")
done
mkdir -p /dev/shm/892-claude "$base/results"
[ -f "$base/bin/harness" ] || cp "$base/bin/compiler-main" "$base/bin/harness"
export EXCLUSIVE_OWNER=claude-892 EXCLUSIVE_TITLE="#892: branch-free sites" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/892
~/buster-fast-bench/exclusive.sh bash -c 'head -n 1 /var/lib/buster-9700x/owner >> "$1"; shift; exec "$@"' held "$base/results/tr-$name.holds" timeout 900 taskset -c 2 "$base/bin/harness" time-runs --runs "$runs" --copies "$copies" --directory /dev/shm/892-claude \
    "${builds[@]}" --list "${ARGS[@]}" > "$base/results/tr-$name.txt" 2> "$base/results/tr-$name.err"
echo "status $?" >> "$base/results/tr-$name.err"
sha256sum "$base"/bin/compiler-* > "$base/results/tr-$name.sha256"
echo done > "$base/results/tr-$name.done"
