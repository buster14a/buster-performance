set -euo pipefail
evidence="$(realpath -m evidence-3637)"
mkdir -p "$evidence"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
cat /proc/loadavg > "$evidence/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evidence/load-before.txt"
base=$(realpath base/build/compiler)
cd pr3637
sqlite_flags=(-c --lanes 1 -march=znver5 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
main_flags=(-c --lanes 1 -march=znver5 -Isrc -fwrapv -funsigned-char --predefines build/predefines.h -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c)
for workload in sqlite main; do
    declare -n flags="${workload}_flags"
    for mode in default shapes; do
        modes=()
        if [[ "$mode" == shapes ]]; then modes=(--tier0-inline-shapes); fi
        taskset -c 2 ./build/compiler measure-compile --runs 11 --reference "$base" -- "${flags[@]}" "${modes[@]}" | tee "$evidence/$workload-$mode.txt"
    done
    unset -n flags
done
cat /proc/loadavg > "$evidence/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evidence/load-after.txt"
