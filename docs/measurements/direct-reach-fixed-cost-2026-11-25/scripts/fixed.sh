#!/bin/bash
# fixed.sh ROUNDS: the direct path's fixed cost a process. Small units by -c, a process each, CPU 2, the object on
# /dev/shm; medians of task-clock, user and kernel cycles, instructions and page faults, for three page policies.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
rounds=${1:-15}
bin=$here/main/build/compiler
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
base=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc)
sys=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
musl=(-D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal" "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
tmp=$(mktemp -d /dev/shm/fixed-np4nn5.XXXXXX)
: > "$tmp/empty.c"
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
printf '#include <stdio.h>\nint main(void) { printf("hello %%d\\n", 1); return 0; }\n' > "$tmp/hello.c"
printf '#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <stdint.h>\n#include <errno.h>\n#include <unistd.h>\nint main(int argc, char** argv) { char* p = malloc(16); strcpy(p, "x"); printf("%%s %%d\\n", p, argc); free(p); return errno; }\n' > "$tmp/six.c"
printf 'int main(void){return 0;}\n' > "$tmp/exit.c"; cc -O2 -static -o "$tmp/exit" "$tmp/exit.c"
declare -A cmd
units=(exit empty add hello six wcwidth sqlite)
args_of() {
    case $1 in
        empty|add) echo "${base[@]} -c $tmp/$1.c";;
        hello|six) echo "${base[@]} ${sys[@]} -c $tmp/$1.c";;
        wcwidth) echo "${base[@]} ${musl[@]} -c $M/src/ctype/wcwidth.c";;
        sqlite) echo "${base[@]} ${sys[@]} -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $C/sqlite/sqlite3.c";;
    esac
}
policies=(default busy nothp nodirect)
run() { # unit policy round
    local u=$1 p=$2 r=$3 env=() extra=()
    case $p in busy) env=(BUSTER_TEST_HOST_BUSY=1);; nothp) env=(BUSTER_HUGE_PAGES=0);; nodirect) extra=(--no-direct);; esac
    if [ "$u" = exit ]; then
        taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$tmp/$u.$p.$r.csv" -- "$tmp/exit" > /dev/null 2>&1
    else
        env "${env[@]}" taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$tmp/$u.$p.$r.csv" -- "$bin" $(args_of "$u") "${extra[@]}" -o "$tmp/out.o" > /dev/null 2>"$tmp/$u.$p.err" || echo "run failed: $u $p $r" >&2
    fi
}
cat /proc/loadavg >&2
for u in "${units[@]}"; do for p in "${policies[@]}"; do run "$u" "$p" warm; done; done
for u in empty add hello six wcwidth sqlite; do "$bin" $(args_of "$u") -o "$tmp/$u.o" 2>/dev/null; echo "$u direct=$(grep -ca 'buster direct' "$tmp/$u.o") size=$(stat -c %s "$tmp/$u.o")"; done
for ((r = 0; r < rounds; r++)); do
    for u in "${units[@]}"; do for p in "${policies[@]}"; do run "$u" "$p" "$r"; done; done
done
med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$3" '$3==e {printf "%.4f\n", $1}' "$tmp/$1.$2.$r.csv"; done | med; }
printf '%-8s %-9s %9s %11s %11s %12s %7s\n' unit policy wall-ms cycles:u cycles:k instr:u faults
for u in "${units[@]}"; do for p in "${policies[@]}"; do
    printf '%-8s %-9s %9.4f %11.0f %11.0f %12.0f %7.0f\n' "$u" "$p" "$(ev $u $p task-clock)" "$(ev $u $p cycles:u)" "$(ev $u $p cycles:k)" "$(ev $u $p instructions:u)" "$(ev $u $p page-faults)"
done; done
cat /proc/loadavg >&2
rm -rf "$tmp"
