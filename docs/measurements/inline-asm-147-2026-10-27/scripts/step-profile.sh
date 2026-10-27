corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
for f in asm plain; do
    taskset -c 2 perf record -q -e cycles:u -c 200003 -o profile-$f.data -- bash -c "for i in \$(seq 30); do head/build/compiler -c ${drive[*]} bench/$f.c -o /dev/null; done" > /dev/null 2>&1
done
