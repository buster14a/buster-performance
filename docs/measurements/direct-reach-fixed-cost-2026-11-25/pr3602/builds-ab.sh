#!/bin/bash
# builds-ab.sh ROUNDS NAME...: Lua's 34 units (its Makefile's flags without -Wall -Wextra, the host's headers) and musl's
# 1,336 (-std=gnu99), a process a unit on CPU 2, objects on /dev/shm, by bin/compiler-NAME, the variants rotated by
# round: a build's wall time, cycles, instructions and faults (perf stat around the loop), medians. One hold.
# BUILDS="lua musl" picks the builds; LUA_FLAGS and MUSL_STD replace the flags.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
rounds=$1; shift
names=("$@")
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
L=$here/lua/src
tmp=$(mktemp -d /dev/shm/builds-np4nn5.XXXXXX)
muslinc=(-nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
luaflags=(${LUA_FLAGS:--std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX})
muslstd=${MUSL_STD:--std=gnu99}
builds=(${BUILDS:-lua musl})
export LC_ALL=C
declare -A seen; mfiles=()
for f in "$M"/src/*/*.c "$M"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; mfiles+=("$f"); fi; done
lfiles=("$L"/*.c)
mkdir -p "$tmp/o"
for n in "${names[@]}"; do
    bin=$here/bin/compiler-$n
    { echo '#!/bin/bash'; for f in "${lfiles[@]}"; do printf '%q ' "$bin" --lanes 1 "${luaflags[@]}" -c "$f" -o "$tmp/o/$(basename "$f" .c).o"; echo; done; } > "$tmp/lua.$n.sh"
    { echo '#!/bin/bash'; for f in "${mfiles[@]}"; do printf '%q ' "$bin" --lanes 1 "${muslinc[@]}" "$muslstd" -c "$f" -o "$tmp/o/$(basename "$f" .c).o"; echo; done; } > "$tmp/musl.$n.sh"
    chmod +x "$tmp"/*.sh
done
cat /proc/loadavg >&2
for b in "${builds[@]}"; do for n in "${names[@]}"; do
    rm -f "$tmp"/o/*.o; "$tmp/$b.$n.sh" > /dev/null 2>&1
    echo "$b $n: objects $(ls "$tmp"/o/*.o | wc -l), direct $(grep -la 'buster direct' "$tmp"/o/*.o | wc -l), hash $(cat "$tmp"/o/*.o | sha256sum | cut -c1-12)"
done; done
count=${#names[@]}
for ((r = 0; r < rounds; r++)); do
    for b in "${builds[@]}"; do for ((k = 0; k < count; k++)); do
        n=${names[$(((k + r) % count))]}
        taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$tmp/$b.$n.$r.csv" -- "$tmp/$b.$n.sh" > /dev/null 2>&1
    done; done
done
med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$3" '$3==e {printf "%.3f\n", $1}' "$tmp/$1.$2.$r.csv"; done | med; }
printf '%-6s %-12s %10s %13s %13s %14s %8s\n' build variant wall-ms cycles:u cycles:k instr:u faults
for b in "${builds[@]}"; do for n in "${names[@]}"; do
    printf '%-6s %-12s %10.2f %13.0f %13.0f %14.0f %8.0f\n' "$b" "$n" "$(ev $b $n task-clock)" "$(ev $b $n cycles:u)" "$(ev $b $n cycles:k)" "$(ev $b $n instructions:u)" "$(ev $b $n page-faults)"
done; done
cat /proc/loadavg >&2
rm -rf "$tmp"
