#!/bin/bash
# bench.sh ROUNDS NAME...: run under the 9700X's lock. Lua 5.4.8's 34 units (its Makefile's flags but -Wall -Wextra,
# the host's headers) and musl's 1,336 (-std=c99), a process a unit on CPU 2, objects on /dev/shm, by bin/compiler-NAME,
# the names rotated by round: a build's wall time, cycles, instructions and faults (perf stat around the loop),
# medians. Then sqlite3.c's -c (the corpus's headers and pinned predefines, as CI's count) by each, perf stat -r 7.
# Adapted from buster-performance direct-predefines-3592-2026-11-27/scripts/builds-ab.sh.
set -uo pipefail
here=/dev/shm/3592-lua-claude
rounds=$1; shift
names=("$@")
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
L=$here/lua/src
tmp=$(mktemp -d /dev/shm/3592-lua-claude/run.XXXXXX)
muslinc=(-nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
luaflags=(-std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
export LC_ALL=C
declare -A seen; mfiles=()
for f in "$M"/src/*/*.c "$M"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; mfiles+=("$f"); fi; done
lfiles=("$L"/*.c)
mkdir -p "$tmp/o"
for n in "${names[@]}"; do
    bin=$here/bin/compiler-$n
    { echo '#!/bin/bash'; for f in "${lfiles[@]}"; do printf '%q ' "$bin" --lanes 1 "${luaflags[@]}" -c "$f" -o "$tmp/o/$(basename "$f" .c).o"; echo; done; } > "$tmp/lua.$n.sh"
    { echo '#!/bin/bash'; for f in "${mfiles[@]}"; do printf '%q ' "$bin" --lanes 1 "${muslinc[@]}" -std=c99 -c "$f" -o "$tmp/o/$(basename "$f" .c).o"; echo; done; } > "$tmp/musl.$n.sh"
    chmod +x "$tmp"/*.sh
done
echo "== before"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
for b in lua musl; do for n in "${names[@]}"; do
    rm -f "$tmp"/o/*.o; "$tmp/$b.$n.sh" > /dev/null 2> "$tmp/$b.$n.err"
    echo "$b $n: objects $(ls "$tmp"/o/*.o | wc -l), direct $(for o in "$tmp"/o/*.o; do readelf -p .comment "$o" 2>/dev/null | grep -q 'buster direct' && echo; done | wc -l), stderr bytes $(wc -c < "$tmp/$b.$n.err")"
done; done
count=${#names[@]}
for ((r = 0; r < rounds; r++)); do
    for b in lua musl; do for ((k = 0; k < count; k++)); do
        n=${names[$(((k + r) % count))]}
        taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$tmp/$b.$n.$r.csv" -- "$tmp/$b.$n.sh" > /dev/null 2>&1
    done; done
done
med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$3" '$3==e {printf "%.3f\n", $1}' "$tmp/$1.$2.$r.csv"; done | med; }
printf '%-6s %-8s %10s %13s %13s %14s %8s\n' build variant wall-ms cycles:u cycles:k instr:u faults
for b in lua musl; do for n in "${names[@]}"; do
    printf '%-6s %-8s %10.2f %13.0f %13.0f %14.0f %8.0f\n' "$b" "$n" "$(ev $b $n task-clock)" "$(ev $b $n cycles:u)" "$(ev $b $n cycles:k)" "$(ev $b $n instructions:u)" "$(ev $b $n page-faults)"
done; done
sflags=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
for n in "${names[@]}"; do
    echo "== sqlite3.c by $n"
    taskset -c 2 perf stat -r 7 -x ';' --no-big-num -e instructions:u,cycles:u,task-clock -- "$here/bin/compiler-$n" "${sflags[@]}" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" -c "$C/sqlite/sqlite3.c" -o "$tmp/s.o" 2>&1 | awk -F';' '{printf "%s %s (+-%s)\n", $3, $1, $4}'
    readelf -p .comment "$tmp/s.o" | grep -o 'buster direct' ; sha256sum < "$tmp/s.o" | cut -c1-16
done
echo "== after"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
rm -rf "$tmp"
