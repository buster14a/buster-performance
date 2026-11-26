set -euo pipefail
out="$(realpath -m evidence-3597)"
mkdir -p "$out"
cat /proc/loadavg > "$out/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-before.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
(cd pr3597 && taskset -c 2 ./build/compiler measure-compile --runs 41 --reference ../base3597/build/compiler -- "${flags[@]}") | tee "$out/results.txt"
for side in base3597 pr3597; do
    "$side/build/compiler" "${flags[@]}" -o "$out/$side.o"
done
sha256sum "$out"/{base3597,pr3597}.o > "$out/objects.sha256"
cat /proc/loadavg > "$out/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-after.txt"
