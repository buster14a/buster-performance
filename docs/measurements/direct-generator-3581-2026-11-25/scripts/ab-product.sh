#!/bin/bash
# ab-product.sh ROUNDS NAME...: bin/compiler-NAME's -c of the frozen sqlite3.c, one compile a process, the variants in an
# order that rotates by round, CPU 2, the object on /dev/shm: the medians over the rounds of the wall time, the user and
# kernel cycles, the instructions and the mispredicted branches, and each object's hash. One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/3581-claude-hape45
rounds=$1; shift
names=("$@")
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
unit=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
sqlite=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
tmp=$(mktemp -d /dev/shm/abp-hape45.XXXXXX)
cat /proc/loadavg >&2
for n in "${names[@]}"; do
    "$here/trees/$n/build/compiler" --version > /dev/null 2>&1 || { echo "cannot run compiler-$n" >&2; exit 1; }
    taskset -c 2 "$here/trees/$n/build/compiler" "${unit[@]}" "${sqlite[@]}" -o "$tmp/$n.o" || echo "FAILED $n" >&2
    sha256sum "$tmp/$n.o" | cut -c1-16 > "$tmp/$n.sha"
done
count=${#names[@]}
for ((r = 0; r < rounds; r++)); do
    for ((k = 0; k < count; k++)); do
        n=${names[$(((k + r) % count))]}
        taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,ex_ret_brn_misp:u,task-clock -o "$tmp/$n.$r.csv" -- \
            "$here/trees/$n/build/compiler" "${unit[@]}" "${sqlite[@]}" -o "$tmp/out.o" > /dev/null 2>&1 || echo "run failed: $n $r" >&2
    done
done
printf '%-16s %9s %10s %10s %11s %9s  %s\n' variant wall-ms cycles:u cycles:k instr:u brmiss object
for n in "${names[@]}"; do
    med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
    ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$1" '$3==e {printf "%.3f\n", $1}' "$tmp/$n.$r.csv"; done | med; }
    printf '%-16s %9.3f %10.0f %10.0f %11.0f %9.0f  %s\n' "$n" "$(ev task-clock)" "$(ev cycles:u)" "$(ev cycles:k)" "$(ev instructions:u)" "$(ev ex_ret_brn_misp:u)" "$(cat "$tmp/$n.sha")"
done
cat /proc/loadavg >&2
rm -rf "$tmp"
