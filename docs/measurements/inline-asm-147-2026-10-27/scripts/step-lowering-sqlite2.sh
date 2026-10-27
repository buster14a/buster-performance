corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
for t in base head head base base head head base base head head base; do
    echo "== $t"
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u $t/build/compiler benchmark-lowering-source "${drive[@]}" "$corpus/sqlite/sqlite3.c" 2>&1 | grep -E "totals|instructions|cycles"
done
