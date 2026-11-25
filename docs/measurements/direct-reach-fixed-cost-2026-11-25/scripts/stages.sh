#!/bin/bash
# stages.sh ROUNDS NAME...: bin/compiler-NAME's --time-stages -c of sqlite3.c on CPU 2, the variants rotated by round:
# medians of the preprocess stage (the direct path's lexing and preprocessing), tier0 (its parsing and code generation),
# the object's write and the setup. One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
rounds=$1; shift
names=("$@")
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
unit=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
      -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
tmp=$(mktemp -d /dev/shm/st-np4nn5.XXXXXX)
count=${#names[@]}
cat /proc/loadavg >&2
for n in "${names[@]}"; do taskset -c 2 "$here/bin/compiler-$n" "${unit[@]}" -o "$tmp/out.o" > /dev/null 2>&1; done
for ((r = 0; r < rounds; r++)); do
    for ((k = 0; k < count; k++)); do
        n=${names[$(((k + r) % count))]}
        taskset -c 2 "$here/bin/compiler-$n" --time-stages "${unit[@]}" -o "$tmp/out.o" > "$tmp/$n.$r.txt" 2>&1
    done
done
med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
st() { for ((r = 0; r < rounds; r++)); do awk -F'\t' -v s="$2" '$1=="time-stage" && $2==s {print $3}' "$tmp/$1.$r.txt"; done | med; }
printf '%-12s %10s %10s %10s %10s\n' variant setup preprocess tier0 object-write
for n in "${names[@]}"; do printf '%-12s %10s %10s %10s %10s\n' "$n" "$(st $n setup)" "$(st $n preprocess)" "$(st $n tier0)" "$(st $n object-write)"; done
grep -h "time-stage" "$tmp/${names[0]}.0.txt" | awk -F'\t' '$3+0 > 0.05 {print $2, $3}' | tr '\n' ';' >&2; echo >&2
cat /proc/loadavg >&2
rm -rf "$tmp"
