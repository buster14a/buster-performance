#!/bin/bash
# abtr.sh NAME ROUNDS RUNS COPIES OFFSETS: for #892, docs/profiling.md's #509 method: ab --lock (one locked time-runs
# process a round, pinned to CPU 2) of time-runs over main's, head's and main's again (the floor) placements, the
# checker's offsets OFFSETS (0 is each tree's own build), from COPIES fresh copies on tmpfs, -c sqlite3.c --lanes 1.
# The lock's holder line goes to results/abtr-NAME.holds at each round.
set -u
base=~/buster-fast-bench/892-claude
name=${1:?name} rounds=${2:?rounds} runs=${3:?runs} copies=${4:?copies} offsets=${5:?offsets}
cd "$base/run" || exit 2
corpus=corpus
ARGS=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17
    -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
    -isystem "$corpus/headers/usr/include"
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite" "$corpus/sqlite/sqlite3.c"
    -c -o "$base/scratch/abtr-sq.o" --lanes 1)
builds=()
for b in main:main head:head main-again:main; do
    for o in $offsets; do
        file=$base/bin/compiler-${b#*:}
        [ "$o" != 0 ] && file=$file-o$o
        builds+=(--build "${b%%:*}" "$file")
    done
done
out=$base/results/abtr-$name
mkdir -p "$out" /dev/shm/892-claude
sha256sum "$base"/bin/compiler-* > "$out/sha256.txt"
cat > "$out/lock.sh" <<'LOCK'
#!/bin/bash
# The lock for one ab run, its holder line appended to the record's receipts first.
exec ~/buster-fast-bench/exclusive.sh bash -c 'head -n 1 /var/lib/buster-9700x/owner >> "$1"; shift; exec "$@"' held "$ABTR_HOLDS" "$@"
LOCK
chmod +x "$out/lock.sh"
export ABTR_HOLDS=$out/holds.txt
export EXCLUSIVE_OWNER=claude-892 EXCLUSIVE_TITLE="#892: branch-free sites" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/892
"$base/bin/harness" ab --rounds "$rounds" --cpu 2 --lock "$out/lock.sh" "$base/bin/harness" \
    -- time-runs --runs "$runs" --copies "$copies" --directory /dev/shm/892-claude "${builds[@]}" --list "${ARGS[@]}" > "$out/ab.txt" 2> "$out/ab.err"
echo "status $?" >> "$out/ab.err"
echo done > "$out/done"
