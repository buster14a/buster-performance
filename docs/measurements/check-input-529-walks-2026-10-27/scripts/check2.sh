#!/bin/bash
# check2.sh TREE OUT MAIN: under one hold, -c of the frozen sqlite3.c (#520's options) by main's compiler and TREE's, by
# both paths and on one lane and eight; every object compared with main's.
set -e
base=~/buster-fast-bench/check-input-529b
out=$base/$2
mkdir -p "$out"
cat > "$out/inner.sh" <<'INNER'
#!/bin/bash
set -e
main=$1; head=$2; out=$3
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
taskset -c 2 "$main" --lanes 1 "${options[@]}" -o "$out/main.o"
for variant in "--lanes 1" "--lanes 8" "--scalar --lanes 1"; do
    taskset -c 0-7 "$head" $variant "${options[@]}" -o "$out/head.o"
    if cmp -s "$out/main.o" "$out/head.o"; then echo "same: $variant"; else echo "DIFFERENT: $variant"; fi
done
for v in main head; do
    if [ $v = main ]; then exe=$main; else exe=$head; fi
    taskset -c 2 "$exe" --time-stages --lanes 1 "${options[@]}" -o "$out/$v-stages.o" 2>&1 | grep -E 'check-input|check-expressions|time-stage	total'
done
INNER
chmod +x "$out/inner.sh"
$base/lock.sh "$out/inner.sh" "$base/$3/build/compiler" "$base/$1/build/compiler" "$out" 2>&1 | grep -v '^\(exclusive.sh\|  title:\|  link:\|  pull request:\)' || true
