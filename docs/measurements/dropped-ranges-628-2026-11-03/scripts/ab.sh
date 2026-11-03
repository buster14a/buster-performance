#!/bin/bash
# ab.sh A B OUT: under one hold of the 9700X's lock, CPU 2, `-c` of the frozen sqlite3.c (the compile_time step's options)
# by tree A's compiler and tree B's: 8 interleaved rounds of a warm-up and `perf stat -r 3` each, the order alternating by
# round, every object compared with A's first; then measure-compile --runs 11 of each with the other as its reference.
# Times are taken inside the hold. The lock's own messages are left out of the output.
set -u
base=~/buster-fast-bench/claude-628
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
        taskset -c 2 perf stat -r 3 -x, -e task-clock,cycles:u,instructions:u,cycles:k,instructions:k,page-faults -o "$out/stat-$v-$round.csv" -- "$exe" "${options[@]}" -o "$out/$v.o"
        cmp "$out/reference.o" "$out/$v.o"
    done
done
taskset -c 2 "$a" measure-compile --runs 11 --directory "$out" --reference "$b" -- "${options[@]}" > "$out/measure-A.txt" 2>&1
taskset -c 2 "$b" measure-compile --runs 11 --directory "$out" --reference "$a" -- "${options[@]}" > "$out/measure-B.txt" 2>&1
INNER
chmod +x "$out/inner.sh"
EXCLUSIVE_OWNER=claude-628 EXCLUSIVE_TITLE="Problem 628 529" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628 \
    ~/buster-fast-bench/exclusive.sh "$out/inner.sh" "$base/$1/build/compiler" "$base/$2/build/compiler" "$out" 2>&1 | grep -v '^\(exclusive.sh\|  title:\|  link:\|  pull request:\)' || true
summarize() {
    awk -F, -v v=$1 '$3 ~ /instructions:u/ { i[++n] = $1 } $3 ~ /cycles:u/ { c[++m] = $1 } $3 ~ /task-clock/ { t[++k] = $1 } $3 ~ /cycles:k/ { kc[++q] = $1 } $3 ~ /page-faults/ { pf[++p] = $1 }
        END { printf "%s: instructions:u %.2f M, cycles:u %.2f M, task-clock %.3f ms, cycles:k %.2f M, faults %d (medians of %d rounds)\n", v, med(i, n) / 1e6, med(c, m) / 1e6, med(t, k), med(kc, q) / 1e6, med(pf, p), n }
        function med(a, n,   i, j, x) { for (i = 1; i <= n; i++) for (j = i + 1; j <= n; j++) if (a[j] < a[i]) { x = a[i]; a[i] = a[j]; a[j] = x } return n % 2 ? a[(n + 1) / 2] : (a[n / 2] + a[n / 2 + 1]) / 2 }' $(ls "$out"/stat-$1-*.csv)
}
summarize A
summarize B
for r in 1 2 3 4 5 6 7 8; do
    printf 'round %s: ' $r
    for v in A B; do awk -F, '$3 ~ /cycles:u/ { printf "%s cycles:u %.1f M  ", "'$v'", $1 / 1e6 } $3 ~ /task-clock/ { printf "%s %.2f ms  ", "'$v'", $1 }' "$out/stat-$v-$r.csv"; done
    echo
done
for v in A B; do echo "== measure $v"; grep -vE '^run [0-9]' "$out/measure-$v.txt" | head -60; done
echo done
