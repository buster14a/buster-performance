#!/bin/bash
# measure-assert.sh ROUNDS: shell.c by -I alone (the sqlite-host configuration) and sqlite3.c by the pinned options, a
# process each on CPU 2, by compiler-m7e, -m7e-p1500, -as and -as-p1500, the variants rotated by round: task-clock,
# user and kernel cycles, user instructions, and the path the object names.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
rounds=$1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
names=(m7e m7e-p1500 as as-p1500)
for n in "${names[@]}"; do "$here/bin/compiler-$n" --version > /dev/null || exit 1; done
sq=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
sh=(-I"$C/sqlite" -c "$C/sqlite/shell.c")
out=$here/step2/measure-assert.txt
: > "$out"
count=${#names[@]}
for ((r = 0; r < rounds; r++)); do
    for ((k = 0; k < count; k++)); do
        n=${names[$(((k + r) % count))]}
        for unit in shell sqlite; do
            if [ $unit = shell ]; then args=("${sh[@]}"); else args=("${sq[@]}"); fi
            perf stat -x, -e task-clock,instructions:u,cycles:u,cycles:k -o "$here/step2/ps.tmp" -- taskset -c 2 "$here/bin/compiler-$n" "${args[@]}" -o /dev/shm/ma-np4nn5.o
            echo "$unit $n $r $(grep -v '^#' "$here/step2/ps.tmp" | grep -v '^$' | awk -F, '{printf "%s=%s ", $3, $1}') $(readelf -p .comment /dev/shm/ma-np4nn5.o | grep -o 'buster[^ ]*' | head -1)" >> "$out"
        done
    done
done
python3 - "$out" <<'PY'
import sys, statistics as st
rows = {}
for line in open(sys.argv[1]):
    f = line.split()
    unit, n = f[0], f[1]
    kv = dict(x.split('=') for x in f[3:] if '=' in x)
    rows.setdefault((unit, n), []).append((float(kv['task-clock']), float(kv['instructions:u']), float(kv['cycles:u']), float(kv['cycles:k']), f[-1]))
for (unit, n), v in sorted(rows.items()):
    print(f"{unit:7s} {n:10s} ms {st.median(x[0] for x in v):8.3f}  instr {st.median(x[1] for x in v)/1e6:9.3f} M  ucyc {st.median(x[2] for x in v)/1e6:9.3f} M  kcyc {st.median(x[3] for x in v)/1e6:7.3f} M  {v[0][4]} (n={len(v)})")
PY
