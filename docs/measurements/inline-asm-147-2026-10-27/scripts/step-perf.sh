corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
for t in base head head base; do taskset -c 2 perf stat -r 11 -e instructions:u,cycles:u,task-clock $t/build/compiler -c "${drive[@]}" "$corpus/sqlite/sqlite3.c" -o /dev/null 2>&1 | sed "s/^/$t: /"; done
taskset -c 2 head/build/compiler time-runs --runs 21 --warmups 3 --list -c "${drive[@]}" bench/asm.c -o /dev/null --list -c "${drive[@]}" bench/plain.c -o /dev/null
for f in asm plain plain asm; do taskset -c 2 perf stat -r 11 -e instructions:u,cycles:u,task-clock head/build/compiler -c "${drive[@]}" bench/$f.c -o /dev/null 2>&1 | sed "s/^/$f: /"; done
