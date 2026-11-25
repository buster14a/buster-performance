#!/bin/bash
# bail.sh ROUNDS NAME: what a unit that leaves the direct path costs. musl's 1,336 units by -std=gnu99, a process a
# unit on CPU 2, split by bin/compiler-NAME's path into the units it takes and the units that leave it; each group's
# build by default and by --no-direct, and the whole build by -std=c99 (where nothing is taken), rotated by round, perf
# stat around each loop, medians. One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
rounds=$1; name=$2
bin=$here/bin/compiler-$name
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
tmp=$(mktemp -d /dev/shm/bail-np4nn5.XXXXXX)
mkdir -p "$tmp/o"
inc=(-nostdinc -ffreestanding -D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal" "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
export LC_ALL=C
declare -A seen; all=()
for f in "$M"/src/*/*.c "$M"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; all+=("$f"); fi; done
: > "$tmp/taken"; : > "$tmp/left"
for f in "${all[@]}"; do
    if "$bin" --lanes 1 "${inc[@]}" -std=gnu99 -c "$f" -o "$tmp/o/x.o" 2>/dev/null && grep -qa 'buster direct' "$tmp/o/x.o"; then echo "$f" >> "$tmp/taken"; else echo "$f" >> "$tmp/left"; fi
done
echo "taken $(wc -l < "$tmp/taken"), left $(wc -l < "$tmp/left")"
gen() { # name list std extra...
    local n=$1 list=$2 std=$3; shift 3
    { echo '#!/bin/bash'; while read -r f; do printf '%q ' "$bin" --lanes 1 "${inc[@]}" "$std" "$@" -c "$f" -o "$tmp/o/$(basename "$f").o"; echo; done < "$list"; } > "$tmp/$n.sh"
    chmod +x "$tmp/$n.sh"
}
cat "$tmp/taken" "$tmp/left" > "$tmp/all"
gen taken-default "$tmp/taken" -std=gnu99
gen taken-nodirect "$tmp/taken" -std=gnu99 --no-direct
gen left-default "$tmp/left" -std=gnu99
gen left-nodirect "$tmp/left" -std=gnu99 --no-direct
gen all-c99 "$tmp/all" -std=c99
gen all-gnu99 "$tmp/all" -std=gnu99
names=(taken-default taken-nodirect left-default left-nodirect all-c99 all-gnu99)
cat /proc/loadavg >&2
count=${#names[@]}
for ((r = 0; r < rounds; r++)); do
    for ((k = 0; k < count; k++)); do
        n=${names[$(((k + r) % count))]}
        taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$tmp/$n.$r.csv" -- "$tmp/$n.sh" > /dev/null 2>&1
    done
done
med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$2" '$3==e {printf "%.3f\n", $1}' "$tmp/$1.$r.csv"; done | med; }
printf '%-15s %10s %13s %13s %14s %8s\n' build wall-ms cycles:u cycles:k instr:u faults
for n in "${names[@]}"; do printf '%-15s %10.2f %13.0f %13.0f %14.0f %8.0f\n' "$n" "$(ev $n task-clock)" "$(ev $n cycles:u)" "$(ev $n cycles:k)" "$(ev $n instructions:u)" "$(ev $n page-faults)"; done
cat /proc/loadavg >&2
cp "$tmp/left" "$here/results/musl-left-$name.txt"
rm -rf "$tmp"
