#!/bin/bash
# stages.sh NAME ROUNDS BUILD...: for #892, ab --lock of -c sqlite3.c --lanes 1 --time-stages by each BUILD from a fresh
# tmpfs copy (fresh-BUILD wrappers around fresh.sh), one locked run each, pinned to CPU 2, in a Williams design's order.
set -u
base=~/buster-fast-bench/892-claude
name=${1:?name} rounds=${2:?rounds}
shift 2
out=$base/results/stages-$name
mkdir -p "$out" /dev/shm/892-claude
trees=()
for build in "$@"; do
    printf '#!/bin/bash\nexec %s/fresh.sh %s "$@"\n' "$base" "$build" > "$out/fresh-$build"
    chmod +x "$out/fresh-$build"
    trees+=("$out/fresh-$build")
done
cat > "$out/lock.sh" <<'LOCK'
#!/bin/bash
exec ~/buster-fast-bench/exclusive.sh bash -c 'head -n 1 /var/lib/buster-9700x/owner >> "$1"; shift; exec "$@"' held "$STAGES_HOLDS" "$@"
LOCK
chmod +x "$out/lock.sh"
export STAGES_HOLDS=$out/holds.txt
export EXCLUSIVE_OWNER=claude-892 EXCLUSIVE_TITLE="#892: branch-free sites" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/892
sha256sum "$base"/bin/compiler-* > "$out/sha256.txt"
corpus=corpus
"$base/bin/harness" ab --rounds "$rounds" --cpu 2 --lock "$out/lock.sh" "${trees[@]}" -- --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" \
    --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" \
    -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
    -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite" "$corpus/sqlite/sqlite3.c" -c -o "$base/scratch/stages-sq.o" --lanes 1 --time-stages \
    > "$out/ab.txt" 2>&1
echo "status $?" >> "$out/ab.txt"
echo done > "$out/done"
