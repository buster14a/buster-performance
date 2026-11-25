#!/bin/bash
# emul.sh ROUNDS NAME: musl's 1,336 units by -std=c99, a process a unit on CPU 2, by bin/compiler-NAME with overlay
# headers that emulate what the direct path doesn't compile: none, weak_alias as a plain declaration, the syscall
# wrappers' and __get_tp's inline assembly as calls, and both. Rotated by round, perf stat around each build, medians.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
rounds=$1; name=$2
bin=$here/bin/compiler-$name
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
tmp=$(mktemp -d /dev/shm/emul-np4nn5.XXXXXX)
mkdir -p "$tmp/o"
export LC_ALL=C
declare -A seen; all=()
for f in "$M"/src/*/*.c "$M"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; all+=("$f"); fi; done
gen() { # name overlay...
    local n=$1; shift
    local ov=(); for o in "$@"; do ov+=(-I "$here/emul/$o"); done
    local inc=(-nostdinc -ffreestanding -D_XOPEN_SOURCE=700 "${ov[@]}" -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
    { echo '#!/bin/bash'; for f in "${all[@]}"; do printf '%q ' "$bin" --lanes 1 -std=c99 "${inc[@]}" -c "$f" -o "$tmp/o/$(basename "$f").o"; echo; done; } > "$tmp/$n.sh"
    chmod +x "$tmp/$n.sh"
}
gen none
gen alias overlay-alias
gen asm overlay-asm
gen both overlay-alias overlay-asm
names=(none alias asm both)
cat /proc/loadavg >&2
for n in "${names[@]}"; do rm -f "$tmp"/o/*.o; "$tmp/$n.sh" > /dev/null 2>&1; echo "$n: objects $(ls "$tmp"/o/*.o | wc -l), direct $(grep -la 'buster direct' "$tmp"/o/*.o | wc -l)"; done
count=${#names[@]}
for ((r = 0; r < rounds; r++)); do
    for ((k = 0; k < count; k++)); do
        n=${names[$(((k + r) % count))]}
        taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,task-clock -o "$tmp/$n.$r.csv" -- "$tmp/$n.sh" > /dev/null 2>&1
    done
done
med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$2" '$3==e {printf "%.3f\n", $1}' "$tmp/$1.$r.csv"; done | med; }
printf '%-6s %10s %13s %13s %14s\n' build wall-ms cycles:u cycles:k instr:u
for n in "${names[@]}"; do printf '%-6s %10.2f %13.0f %13.0f %14.0f\n' "$n" "$(ev $n task-clock)" "$(ev $n cycles:u)" "$(ev $n cycles:k)" "$(ev $n instructions:u)"; done
cat /proc/loadavg >&2
rm -rf "$tmp"
