#!/bin/bash
# builds.sh ROUNDS: a build as make runs it, a process a unit, CPU 2, objects on /dev/shm: Lua's 34 units and musl's 1,336,
# with their own flags and with flags the direct path admits, under the default pages and BUSTER_HUGE_PAGES=0.
# Prints a build's wall time and its user and kernel cycles (perf stat over the whole loop), medians of ROUNDS.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
rounds=${1:-5}
bin=$here/main/build/compiler
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
L=$here/lua/src
tmp=$(mktemp -d /dev/shm/builds-np4nn5.XXXXXX)
sys=(--target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
muslinc=(-nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
export LC_ALL=C
declare -A seen; mfiles=()
for f in "$M"/src/*/*.c "$M"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; mfiles+=("$f"); fi; done
lfiles=("$L"/*.c)
gen() { # name: writes $tmp/name.sh, a loop of one process a unit
    local name=$1; shift
    local kind=$1; shift
    { echo '#!/bin/bash'
      if [ "$kind" = lua ]; then for f in "${lfiles[@]}"; do printf '%q ' "$bin" --lanes 1 "${sys[@]}" "$@" -c "$f" -o "$tmp/o/$(basename "$f" .c).o"; echo; done
      else for f in "${mfiles[@]}"; do printf '%q ' "$bin" --lanes 1 "${muslinc[@]}" "$@" -c "$f" -o "$tmp/o/$(basename "$f" .c).o"; echo; done; fi
    } > "$tmp/$name.sh"; chmod +x "$tmp/$name.sh"
}
mkdir -p "$tmp/o"
gen lua-real lua -std=gnu99 -O2 -Wall -Wextra -DLUA_COMPAT_5_3 -DLUA_USE_LINUX
gen lua-plain lua -std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX
gen musl-c99 musl -std=c99
gen musl-gnu99 musl -std=gnu99
names=(lua-real lua-plain musl-c99 musl-gnu99)
cat /proc/loadavg >&2
for n in "${names[@]}"; do
    rm -f "$tmp"/o/*.o; "$tmp/$n.sh" > /dev/null 2> "$tmp/$n.err"; echo "$n: objects $(ls "$tmp"/o/*.o | wc -l), direct $(grep -la 'buster direct' "$tmp"/o/*.o | wc -l), stderr lines $(wc -l < "$tmp/$n.err")"
done
for ((r = 0; r < rounds; r++)); do
    for n in "${names[@]}"; do for p in default nothp; do
        if [ $p = nothp ]; then export BUSTER_HUGE_PAGES=0; else unset BUSTER_HUGE_PAGES; fi
        taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$tmp/$n.$p.$r.csv" -- "$tmp/$n.sh" > /dev/null 2>&1
    done; done
done
unset BUSTER_HUGE_PAGES
med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$3" '$3==e {printf "%.3f\n", $1}' "$tmp/$1.$2.$r.csv"; done | med; }
printf '%-11s %-8s %10s %13s %13s %14s %8s\n' build pages wall-ms cycles:u cycles:k instr:u faults
for n in "${names[@]}"; do for p in default nothp; do
    printf '%-11s %-8s %10.2f %13.0f %13.0f %14.0f %8.0f\n' "$n" "$p" "$(ev $n $p task-clock)" "$(ev $n $p cycles:u)" "$(ev $n $p cycles:k)" "$(ev $n $p instructions:u)" "$(ev $n $p page-faults)"
done; done
cat /proc/loadavg >&2
rm -rf "$tmp"
