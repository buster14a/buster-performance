#!/bin/bash
# resident.sh ROUNDS PRODUCT HARNESS: musl's units that the direct path takes (-std=gnu99), on CPU 2, objects on /dev/shm:
# a process a unit by bin/compiler-PRODUCT, and all of them in one process by bin/resident-HARNESS. perf stat around
# each, medians of ROUNDS; the harness's own stage times from its last round. One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
rounds=$1; product=$2; harness=$3
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
tmp=$(mktemp -d /dev/shm/res-np4nn5.XXXXXX)
mkdir -p "$tmp/o"
inc=(-D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal" "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
bin=$here/bin/compiler-$product
export LC_ALL=C
declare -A seen; all=()
for f in "$M"/src/*/*.c "$M"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; all+=("$f"); fi; done
# the units the product's direct path takes
: > "$tmp/list"
for f in "${all[@]}"; do "$bin" --lanes 1 -nostdinc -ffreestanding -std=gnu99 "${inc[@]}" -c "$f" -o "$tmp/o/x.o" 2>/dev/null && grep -qa 'buster direct' "$tmp/o/x.o" && echo "$f" >> "$tmp/list"; done
echo "units the direct path takes: $(wc -l < "$tmp/list")"
: > "$tmp/empty.c"
"$bin" -dM -E -std=gnu99 -ffreestanding -nostdinc "$tmp/empty.c" > "$tmp/predefines.txt" 2>/dev/null
{ echo '#!/bin/bash'; while read -r f; do printf '%q ' "$bin" --lanes 1 -nostdinc -ffreestanding -std=gnu99 "${inc[@]}" -c "$f" -o "$tmp/o/$(basename "$f").o"; echo; done < "$tmp/list"; } > "$tmp/processes.sh"
{ echo '#!/bin/bash'; printf '%q ' "$here/bin/resident-$harness" "${inc[@]}" --predefines "$tmp/predefines.txt" --list "$tmp/list" --out "$tmp/o"; echo; } > "$tmp/resident.sh"
chmod +x "$tmp"/*.sh
cat /proc/loadavg >&2
"$tmp/processes.sh"; cat "$tmp"/o/*.o | sha256sum | cut -c1-12
rm -f "$tmp"/o/*.o; "$tmp/resident.sh" | tail -1; cat "$tmp"/o/*.o | sha256sum | cut -c1-12
for ((r = 0; r < rounds; r++)); do
    for n in processes resident; do
        taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$tmp/$n.$r.csv" -- "$tmp/$n.sh" > "$tmp/$n.$r.out" 2>&1
    done
done
med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$2" '$3==e {printf "%.3f\n", $1}' "$tmp/$1.$r.csv"; done | med; }
printf '%-10s %10s %13s %13s %14s %8s\n' way wall-ms cycles:u cycles:k instr:u faults
for n in processes resident; do printf '%-10s %10.2f %13.0f %13.0f %14.0f %8.0f\n' "$n" "$(ev $n task-clock)" "$(ev $n cycles:u)" "$(ev $n cycles:k)" "$(ev $n instructions:u)" "$(ev $n page-faults)"; done
cat "$tmp/resident.$((rounds - 1)).out"
cat /proc/loadavg >&2
rm -rf "$tmp"
