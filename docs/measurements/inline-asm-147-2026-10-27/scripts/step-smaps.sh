corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
for t in base head; do
    echo "== $t"
    taskset -c 2 gdb -q -batch -iex "set debuginfod enabled off" -ex 'catch syscall munmap' -ex 'condition 1 $rsi > 0x4000000' -ex run -ex 'source bench/smaps.py' -ex kill --args $t/build/compiler -c "${drive[@]}" "$corpus/sqlite/sqlite3.c" -o /dev/null 2>&1 | grep -v "^\[\|^Catchpoint\|^Using\|^0x"
done
