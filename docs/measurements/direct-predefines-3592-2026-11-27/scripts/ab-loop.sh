#!/bin/bash
# ab-loop.sh ROUNDS N UNIT SPEC...: SPEC is NAME or NAME@VAR=VALUE (bin/compiler-NAME with that environment). Each round
# runs each spec's N compiles of UNIT in a loop under perf stat on CPU 2, in an order that rotates by round; prints per
# compile medians: wall (task-clock of the loop / N), user and kernel cycles, user instructions, faults; and each spec's
# object hash. One hold.
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude2
rounds=$1; n=$2; unit=$3; shift 3
specs=("$@")
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
base=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc)
sys=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
musl=(-D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal" "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
tmp=$(mktemp -d /dev/shm/abl-3586.XXXXXX)
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
printf '#include <stdio.h>\nint main(void) { printf("hello %%d\\n", 1); return 0; }\n' > "$tmp/hello.c"
printf '#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <stdint.h>\n#include <errno.h>\n#include <unistd.h>\n#include <math.h>\nint main(int argc, char** argv) { char* p = malloc(16); strcpy(p, "x"); printf("%%s %%d %%f\\n", p, argc, sqrt(argc)); free(p); return errno; }\n' > "$tmp/six.c"
case $unit in
    add) args=("${base[@]}" -c "$tmp/add.c");;
    plain-add) args=(--lanes 1 -c "$tmp/add.c");;
    hello|six) args=("${base[@]}" "${sys[@]}" -c "$tmp/$unit.c");;
    wcwidth) args=("${base[@]}" "${musl[@]}" -c "$M/src/ctype/wcwidth.c");;
    sqlite) args=("${base[@]}" "${sys[@]}" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c");;
esac
printf '#!/bin/bash\nfor ((i = 0; i < %d; i++)); do "$@"; done\n' "$n" > "$tmp/loop.sh"; chmod +x "$tmp/loop.sh"
run_spec() { # spec, prefix command words..., then -- and the output path
    local spec=$1; shift
    local name=${spec%%@*} envs=() pre=()
    [ "$name" != "$spec" ] && IFS='@' read -r -a envs <<< "${spec#*@}"
    while [ "$1" != "@@" ]; do pre+=("$1"); shift; done; shift
    env "${envs[@]}" "${pre[@]}" "$here/bin/compiler-$name" "${args[@]}" -o "$1"
}
cat /proc/loadavg
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -n 6
for s in "${specs[@]}"; do
    run_spec "$s" taskset -c 2 @@ "$tmp/obj.o" > /dev/null 2>&1 || true
    rm -f "$tmp/obj.o"; run_spec "$s" taskset -c 2 @@ "$tmp/obj.o" > /dev/null 2>"$tmp/err.txt"; st=$?
    echo "$s: status $st object $(sha256sum "$tmp/obj.o" | cut -c1-12) path $(readelf -p .comment "$tmp/obj.o" 2>/dev/null | grep -o 'buster[- a-z]*' | head -n 1)"
done
count=${#specs[@]}
for ((r = 0; r < rounds; r++)); do
    for ((k = 0; k < count; k++)); do
        s=${specs[$(((k + r) % count))]}
        tag=$(echo "$s" | tr '@=/' '___')
        run_spec "$s" taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$tmp/$tag.$r.csv" -- "$tmp/loop.sh" @@ "$tmp/obj.o" > /dev/null 2>&1
    done
done
med() { sort -g | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$2" -v n="$n" '$3==e {printf "%.6f\n", $1 / n}' "$tmp/$1.$r.csv"; done | med; }
printf '%-28s %9s %11s %11s %12s %8s\n' spec wall-ms cycles:u cycles:k instr:u faults
for s in "${specs[@]}"; do
    tag=$(echo "$s" | tr '@=/' '___')
    printf '%-28s %9.4f %11.0f %11.0f %12.0f %8.1f\n' "$s" "$(ev $tag task-clock)" "$(ev $tag cycles:u)" "$(ev $tag cycles:k)" "$(ev $tag instructions:u)" "$(ev $tag page-faults)"
done
cat /proc/loadavg
rm -rf "$tmp"
