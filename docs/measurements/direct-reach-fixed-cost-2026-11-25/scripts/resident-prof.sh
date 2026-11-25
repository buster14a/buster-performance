#!/bin/bash
# resident-prof.sh HARNESS: the one-process loop over musl's direct units: the same loop over 663 empty units (what a
# unit pays before its own text), and the real loop's cycles by symbol.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
harness=$1
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
tmp=$(mktemp -d /dev/shm/resp-np4nn5.XXXXXX)
mkdir -p "$tmp/o"
inc=(-D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal" "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
bin=$here/bin/compiler-s1g
export LC_ALL=C
declare -A seen; all=()
for f in "$M"/src/*/*.c "$M"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; all+=("$f"); fi; done
: > "$tmp/list"
for f in "${all[@]}"; do "$bin" --lanes 1 -nostdinc -ffreestanding -std=gnu99 "${inc[@]}" -c "$f" -o "$tmp/o/x.o" 2>/dev/null && grep -qa 'buster direct' "$tmp/o/x.o" && echo "$f" >> "$tmp/list"; done
: > "$tmp/empty.c"
"$bin" -dM -E -std=gnu99 -ffreestanding -nostdinc "$tmp/empty.c" > "$tmp/predefines.txt" 2>/dev/null
: > "$tmp/empties"; for i in $(seq 663); do cp "$tmp/empty.c" "$tmp/e$i.c"; echo "$tmp/e$i.c" >> "$tmp/empties"; done
R=("$here/bin/resident-$harness" "${inc[@]}" --predefines "$tmp/predefines.txt" --out "$tmp/o")
echo "=== 663 empty units"
for i in 1 2 3; do taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,page-faults,task-clock -o "$tmp/e.csv" -- "${R[@]}" --list "$tmp/empties" | tail -1; awk -F';' '{printf "%s=%s ", $3, $1}' "$tmp/e.csv"; echo; done
echo "=== 663 real units"
for i in 1 2 3; do taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,page-faults,task-clock -o "$tmp/e.csv" -- "${R[@]}" --list "$tmp/list" | tail -1; awk -F';' '{printf "%s=%s ", $3, $1}' "$tmp/e.csv"; echo; done
echo "=== cycles by symbol, real units, 8 rounds"
taskset -c 2 perf record -q -e cycles -c 100003 -o "$tmp/cy.data" -- "${R[@]}" --list "$tmp/list" --rounds 8 > /dev/null 2>&1
perf report -i "$tmp/cy.data" --sort sym --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" | head -60
echo "=== system calls, one round"
strace -c -o "$tmp/st.txt" "${R[@]}" --list "$tmp/list" > /dev/null 2>&1; head -16 "$tmp/st.txt"
rm -rf "$tmp"
