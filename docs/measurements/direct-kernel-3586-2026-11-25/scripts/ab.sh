#!/bin/bash
# ab.sh ROUNDS NAME...: bin/compiler-NAME's -c of small units and of sqlite3.c, a process each, CPU 2, the object on
# /dev/shm, the variants in an order that rotates by round. Each run is counted twice: by the process's own counters
# (perf stat of the command: user and kernel cycles, user instructions, faults, task-clock), and by CPU 2's counters
# while `waitall` waits for the command and for the exit helper it leaves (cpu-k, cpu-u: the address space's teardown
# included). Medians, and each object's hash. One hold. AB_UNITS="add six" picks the units.
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude
rounds=$1; shift
names=("$@")
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
base=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc)
sys=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
musl=(-D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal" "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
tmp=$(mktemp -d /dev/shm/ab-3586.XXXXXX)
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
printf '#include <stdio.h>\nint main(void) { printf("hello %%d\\n", 1); return 0; }\n' > "$tmp/hello.c"
printf '#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <stdint.h>\n#include <errno.h>\n#include <unistd.h>\n#include <math.h>\nint main(int argc, char** argv) { char* p = malloc(16); strcpy(p, "x"); printf("%%s %%d %%f\\n", p, argc, sqrt(argc)); free(p); return errno; }\n' > "$tmp/six.c"
units=(${AB_UNITS:-add hello six wcwidth sqlite})
args_of() {
    case $1 in
        add) echo "${base[@]} -c $tmp/$1.c";;
        hello|six) echo "${base[@]} ${sys[@]} -c $tmp/$1.c";;
        wcwidth) echo "${base[@]} ${musl[@]} -c $M/src/ctype/wcwidth.c";;
        sqlite) echo "${base[@]} ${sys[@]} -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $C/sqlite/sqlite3.c";;
    esac
}
cat /proc/loadavg >&2
for n in "${names[@]}"; do
    chmod +x "$here/bin/compiler-$n"; "$here/bin/compiler-$n" --version > /dev/null 2>&1 || { echo "cannot run compiler-$n" >&2; exit 1; }
    for u in "${units[@]}"; do
        taskset -c 2 "$here/bin/compiler-$n" $(args_of "$u") -o "$tmp/$n.$u.o" 2>/dev/null || echo "FAILED $n $u" >&2
        echo "$(sha256sum "$tmp/$n.$u.o" | cut -c1-12) $(grep -ca 'buster direct' "$tmp/$n.$u.o")" > "$tmp/$n.$u.sha"
    done
done
count=${#names[@]}
for ((r = 0; r < rounds; r++)); do
    for u in "${units[@]}"; do
        for ((k = 0; k < count; k++)); do
            n=${names[$(((k + r) % count))]}
            taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$tmp/$n.$u.$r.csv" -- \
                "$here/bin/compiler-$n" $(args_of "$u") -o "$tmp/out.o" > /dev/null 2>&1 || echo "run failed: $n $u $r" >&2
            perf stat -C 2 -x ';' --no-big-num -e cycles:k,cycles:u -o "$tmp/$n.$u.$r.cpu" -- \
                taskset -c 2 "$here/waitall" "$here/bin/compiler-$n" $(args_of "$u") -o "$tmp/out.o" > /dev/null 2>&1 || echo "cpu run failed: $n $u $r" >&2
        done
    done
done
med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$3" '$3==e {printf "%.4f\n", $1}' "$tmp/$1.$2.$r.$4"; done | med; }
printf '%-8s %-10s %9s %11s %11s %12s %7s %11s %11s  %s\n' unit variant wall-ms cycles:u cycles:k instr:u faults cpu-k cpu-u "object direct"
for u in "${units[@]}"; do for n in "${names[@]}"; do
    printf '%-8s %-10s %9.4f %11.0f %11.0f %12.0f %7.0f %11.0f %11.0f  %s\n' "$u" "$n" "$(ev $n $u task-clock csv)" "$(ev $n $u cycles:u csv)" "$(ev $n $u cycles:k csv)" "$(ev $n $u instructions:u csv)" "$(ev $n $u page-faults csv)" "$(ev $n $u cycles:k cpu)" "$(ev $n $u cycles:u cpu)" "$(cat "$tmp/$n.$u.sha")"
done; done
cat /proc/loadavg >&2
rm -rf "$tmp"
