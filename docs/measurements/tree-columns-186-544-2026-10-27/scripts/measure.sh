#!/bin/bash
# measure.sh A B OUT: under one hold of the 9700X's lock, CPU 2, `-c` of the frozen sqlite3.c (#520's step's options) by
# tree A's compiler and tree B's, interleaved: 8 rounds of a warm-up and `perf stat -r 3` each, the order alternating by
# round, every object compared with A's first; then 11 rounds of each with --time-stages, alternating, for the stages.
set -e
base=~/buster-fast-bench/tree-186-544-claude
out=$base/$3
mkdir -p "$out"
cat > "$out/inner.sh" <<'INNER'
#!/bin/bash
set -e
a=$1; b=$2; out=$3
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
taskset -c 2 "$a" "${options[@]}" -o "$out/reference.o"
for round in 1 2 3 4 5 6 7 8; do
    if [ $((round % 2)) = 1 ]; then order="A B"; else order="B A"; fi
    for v in $order; do
        if [ $v = A ]; then exe=$a; else exe=$b; fi
        taskset -c 2 "$exe" "${options[@]}" -o "$out/warm-$v.o"
        taskset -c 2 perf stat -r 3 -x, -e task-clock,cycles:u,instructions:u,cycles:k,page-faults -o "$out/stat-$v-$round.csv" -- "$exe" "${options[@]}" -o "$out/$v.o"
        cmp "$out/reference.o" "$out/$v.o"
    done
done
for round in $(seq 1 11); do
    if [ $((round % 2)) = 1 ]; then order="A B"; else order="B A"; fi
    for v in $order; do
        if [ $v = A ]; then exe=$a; else exe=$b; fi
        taskset -c 2 "$exe" "${options[@]}" --lanes 1 --time-stages -o "$out/stages-$v.o" 2> "$out/stages-$v-$round.txt"
        cmp "$out/reference.o" "$out/stages-$v.o"
    done
done
INNER
chmod +x "$out/inner.sh"
$base/lock.sh "$out/inner.sh" "$base/$1/build/compiler" "$base/$2/build/compiler" "$out" 2>&1 | grep -v '^\(exclusive.sh\|  title:\|  link:\|  pull request:\)' || true
summarize() {
    awk -F, -v v=$1 '$3 ~ /instructions:u/ { i[++n] = $1 } $3 ~ /cycles:u/ { c[++m] = $1 } $3 ~ /task-clock/ { t[++k] = $1 } $3 ~ /cycles:k/ { kc[++q] = $1 } $3 ~ /page-faults/ { pf[++r] = $1 }
        END { printf "%s: instructions:u %.2f M, cycles:u %.2f M, task-clock %.3f ms, cycles:k %.2f M, page-faults %.0f (medians of %d rounds)\n", v, med(i, n) / 1e6, med(c, m) / 1e6, med(t, k), med(kc, q) / 1e6, med(pf, r), n }
        function med(a, n,   i, j, x) { for (i = 1; i <= n; i++) for (j = i + 1; j <= n; j++) if (a[j] < a[i]) { x = a[i]; a[i] = a[j]; a[j] = x } return n % 2 ? a[(n + 1) / 2] : (a[n / 2] + a[n / 2 + 1]) / 2 }' $(ls "$out"/stat-$1-*.csv)
}
summarize A
summarize B
for r in 1 2 3 4 5 6 7 8; do
    printf 'round %s: ' $r
    for v in A B; do awk -F, '$3 ~ /cycles:u/ { c = $1 } $3 ~ /instructions:u/ { i = $1 } END { printf "%s cycles:u %.2f M instructions:u %.2f M  ", "'$v'", c / 1e6, i / 1e6 }' "$out/stat-$v-$r.csv"; done
    echo
done
for st in setup preprocess parse type-table check-input check-expressions check-declarations check-program lower span; do
    for v in A B; do
        cat "$out"/stages-$v-*.txt | awk -v s=$st '$1 == "time-stage" && $2 == s { print $3, $5, $6, $7 }' | sort -n | awk -v s=$st -v v=$v '{ ms[NR] = $1; sys[NR] = $2; pf[NR] = $3; kb[NR] = $4 } END { m = int((NR + 1) / 2); printf "%-20s %s: %8.3f ms (min %8.3f max %8.3f) sys %s faults %s peak+ %s KB\n", s, v, ms[m], ms[1], ms[NR], sys[m], pf[m], kb[m] }'
    done
done
