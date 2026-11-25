#!/bin/bash
# ab-pgo.sh ROUNDS NAME...: bin/compiler-NAME on six workloads, the variants in an order that rotates by round, CPU 2,
# objects on /dev/shm, perf stat around each workload (a process a unit): the frozen sqlite3.c's -c 5 times (the direct
# path), its -c --no-direct twice and its -fsyntax-only twice (the full pipeline), musl's 1,336 units by -std=gnu99 (663
# direct), and Lua 5.4.8's 34 units with its Makefile's flags (none direct) and without -Wall -Wextra (29 direct).
# Prints each workload's medians over the rounds: wall ms (task-clock), user and kernel cycles, user instructions,
# and, from a first pass, how many objects the direct path wrote and a hash of all of them. One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/3582-claude
rounds=$1; shift
names=("$@")
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
L=$here/lua/src
tmp=$(mktemp -d /dev/shm/ab-3582.XXXXXX)
sys=(--target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
sqlite=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" "${sys[@]}" -std=gnu17
        -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
muslinc=(-nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal"
         -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
export LC_ALL=C
declare -A seen; mfiles=()
for f in "$M"/src/*/*.c "$M"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; mfiles+=("$f"); fi; done
lfiles=("$L"/*.c)
works=(sq-direct sq-nodirect sq-syntax musl lua-plain lua-real)
gen() { # NAME: $tmp/NAME/WORK.sh for each workload, objects into $tmp/NAME/o
    local n=$1 bin=$here/bin/compiler-$1 o=$tmp/$1/o
    mkdir -p "$o"
    { echo '#!/bin/bash'; for i in 1 2 3 4 5; do printf '%q ' "$bin" "${sqlite[@]}" -c -o "$o/sqlite3.o"; echo; done; } > "$tmp/$n/sq-direct.sh"
    { echo '#!/bin/bash'; for i in 1 2; do printf '%q ' "$bin" --no-direct "${sqlite[@]}" -c -o "$o/sqlite3-nodirect.o"; echo; done; } > "$tmp/$n/sq-nodirect.sh"
    { echo '#!/bin/bash'; for i in 1 2; do printf '%q ' "$bin" "${sqlite[@]}" -fsyntax-only; echo; done; } > "$tmp/$n/sq-syntax.sh"
    { echo '#!/bin/bash'; for f in "${mfiles[@]}"; do printf '%q ' "$bin" --lanes 1 "${muslinc[@]}" -std=gnu99 -c "$f" -o "$o/musl-$(basename "$f" .c).o"; echo; done; } > "$tmp/$n/musl.sh"
    { echo '#!/bin/bash'; for f in "${lfiles[@]}"; do printf '%q ' "$bin" --lanes 1 -std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c "$f" -o "$o/lua-plain-$(basename "$f" .c).o"; echo; done; } > "$tmp/$n/lua-plain.sh"
    { echo '#!/bin/bash'; for f in "${lfiles[@]}"; do printf '%q ' "$bin" --lanes 1 -std=gnu99 -O2 -Wall -Wextra -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c "$f" -o "$o/lua-real-$(basename "$f" .c).o"; echo; done; } > "$tmp/$n/lua-real.sh"
    chmod +x "$tmp/$n"/*.sh
}
cat /proc/loadavg >&2
for n in "${names[@]}"; do
    "$here/bin/compiler-$n" --version > /dev/null 2>&1 || { echo "cannot run compiler-$n" >&2; exit 1; }
    gen "$n"
    for w in "${works[@]}"; do
        "$tmp/$n/$w.sh" > /dev/null 2> "$tmp/$n/$w.err" || echo "FAILED $n $w" >&2
    done
    o=$tmp/$n/o
    for w in musl lua-plain lua-real; do
        echo "$n $w: objects $(ls "$o"/$w-*.o | wc -l), direct $(grep -la 'buster direct' "$o"/$w-*.o | wc -l), stderr lines $(wc -l < "$tmp/$n/$w.err")" >&2
    done
    echo "$n sqlite: direct object $(grep -ca 'buster direct' "$o/sqlite3.o"), --no-direct's $(grep -ca 'buster direct' "$o/sqlite3-nodirect.o")" >&2
    (cd "$o" && sha256sum *.o | sha256sum | cut -c1-16) > "$tmp/$n.sha"
done
count=${#names[@]}
for ((r = 0; r < rounds; r++)); do
    for ((k = 0; k < count; k++)); do
        n=${names[$(((k + r) % count))]}
        for w in "${works[@]}"; do
            taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,task-clock -o "$tmp/$n/$w.$r.csv" -- "$tmp/$n/$w.sh" > /dev/null 2>&1 || echo "run failed: $n $w $r" >&2
        done
    done
done
med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$3" '$3==e {printf "%.3f\n", $1}' "$tmp/$1/$2.$r.csv"; done | med; }
for w in "${works[@]}"; do
    echo "== $w"
    printf '%-16s %10s %12s %12s %13s\n' variant wall-ms cycles:u cycles:k instr:u
    for n in "${names[@]}"; do
        printf '%-16s %10.2f %12.0f %12.0f %13.0f\n' "$n" "$(ev "$n" "$w" task-clock)" "$(ev "$n" "$w" cycles:u)" "$(ev "$n" "$w" cycles:k)" "$(ev "$n" "$w" instructions:u)"
    done
done
echo "== objects"
for n in "${names[@]}"; do echo "$n $(cat "$tmp/$n.sha")"; done
cat /proc/loadavg >&2
rm -rf "$tmp"
