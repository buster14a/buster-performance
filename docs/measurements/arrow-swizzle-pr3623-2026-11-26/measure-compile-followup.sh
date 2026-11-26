set -euo pipefail
side=$1
evidence="$(realpath -m "evidence-${side#pr}-compile")"
mkdir -p "$evidence"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
cat /proc/loadavg > "$evidence/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evidence/load-before.txt"
base=$(realpath base/build/compiler)
cd "$side"
sqlite_flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
main_flags=(-c -Isrc -fwrapv -funsigned-char --predefines build/predefines.h -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c)
if [[ "$side" == pr3623 ]]; then
    taskset -c 2 ./build/compiler measure-compile --runs 41 --reference "$base" -- "${sqlite_flags[@]}" | tee "$evidence/sqlite.txt"
else
    for workload in sqlite main; do
        declare -n flags="${workload}_flags"
        taskset -c 2 ./build/compiler measure-compile --runs 11 --reference "$base" -- --tier1 --tier1-passes=+vectorize,+unroll -O2 -march=znver5 "${flags[@]}" | tee "$evidence/$workload.txt"
        for compiler in "$base" ./build/compiler; do
            label=base
            if [[ "$compiler" == ./build/compiler ]]; then label=head; fi
            taskset -c 2 "$compiler" --tier1 --tier1-passes=+vectorize,+unroll -O2 -march=znver5 "${flags[@]}" -o "$evidence/$workload-$label.o"
            size "$evidence/$workload-$label.o" >> "$evidence/$workload-size.txt"
        done
        unset -n flags
    done
fi
cat /proc/loadavg > "$evidence/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evidence/load-after.txt"
