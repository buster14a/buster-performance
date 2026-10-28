#!/bin/bash
# measure.sh A B OUT: under one hold of the 9700X's lock, CPU 2, `-c` of the frozen sqlite3.c (#520's step's options) by
# tree A's compiler and tree B's, interleaved: 8 rounds of a warm-up and `perf stat -r 3` each, the order alternating by
# round; every object compared with A's first. Then `benchmark-checker-bindings --only direct` of the same file by both
# (the reader alone, as CI runs it), 11 passes each. The lock's own messages are left out of the output.
set -e
base=~/buster-fast-bench/check-input-529b
out=$base/$3
mkdir -p "$out"
cat > "$out/inner.sh" <<'INNER'
#!/bin/bash
set -e
a=$1; b=$2; out=$3
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
taskset -c 2 "$a" "${options[@]}" -o "$out/reference.o"
for round in 1 2 3 4 5 6 7 8; do
    if [ $((round % 2)) = 1 ]; then order="A B"; else order="B A"; fi
    for v in $order; do
        if [ $v = A ]; then exe=$a; else exe=$b; fi
        taskset -c 2 "$exe" "${options[@]}" -o "$out/warm-$v.o"
        taskset -c 2 perf stat -r 3 -x, -e task-clock,cycles:u,instructions:u,cycles:k -o "$out/stat-$v-$round.csv" -- "$exe" "${options[@]}" -o "$out/$v.o"
        cmp "$out/reference.o" "$out/$v.o"
    done
done
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
system=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
for v in A B; do
    if [ $v = A ]; then exe=$a; else exe=$b; fi
    taskset -c 2 "$exe" benchmark-checker-bindings --only direct --passes 11 "${system[@]}" "$corpus/sqlite/sqlite3.c" > "$out/bindings-$v.txt"
done
INNER
chmod +x "$out/inner.sh"
$base/lock.sh "$out/inner.sh" "$base/$1/build/compiler" "$base/$2/build/compiler" "$out" 2>&1 | grep -v '^\(exclusive.sh\|  title:\|  link:\|  pull request:\)' || true
summarize() {
    awk -F, -v v=$1 '$3 ~ /instructions:u/ { i[++n] = $1 } $3 ~ /cycles:u/ { c[++m] = $1 } $3 ~ /task-clock/ { t[++k] = $1 } $3 ~ /cycles:k/ { kc[++q] = $1 }
        END { printf "%s: instructions:u %.1f M, cycles:u %.1f M, task-clock %.2f ms, cycles:k %.1f M (medians of %d rounds)\n", v, med(i, n) / 1e6, med(c, m) / 1e6, med(t, k), med(kc, q) / 1e6, n }
        function med(a, n,   i, j, x) { for (i = 1; i <= n; i++) for (j = i + 1; j <= n; j++) if (a[j] < a[i]) { x = a[i]; a[i] = a[j]; a[j] = x } return n % 2 ? a[(n + 1) / 2] : (a[n / 2] + a[n / 2 + 1]) / 2 }' $(ls "$out"/stat-$1-*.csv)
}
summarize A
summarize B
for r in 1 2 3 4 5 6 7 8; do
    printf 'round %s: ' $r
    for v in A B; do awk -F, '$3 ~ /cycles:u/ { printf "%s cycles:u %.1f M  ", "'$v'", $1 / 1e6 }' "$out/stat-$v-$r.csv"; done
    echo
done
for v in A B; do echo "== bindings $v"; grep -iE 'direct|tokens' "$out/bindings-$v.txt" | head -6; done
