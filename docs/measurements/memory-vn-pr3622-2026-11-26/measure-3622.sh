set -euo pipefail
mkdir -p evidence-3622
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
cat /proc/loadavg > evidence-3622/load-before.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> evidence-3622/load-before.txt
flags=(--tier1 -O2 -march=znver5 --tier1-passes=+memory -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
for side in base pr3622; do
    taskset -c 2 "$side/build/compiler" "${flags[@]}" -o "$side-memory-sqlite.o"
done
cmp base-memory-sqlite.o pr3622-memory-sqlite.o
sha256sum base-memory-sqlite.o pr3622-memory-sqlite.o > evidence-3622/hashes.txt
(cd pr3622 && taskset -c 2 ./build/compiler measure-compile --runs 21 --reference ../base/build/compiler -- "${flags[@]}") | tee evidence-3622/compile.txt
cat /proc/loadavg > evidence-3622/load-after.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> evidence-3622/load-after.txt
