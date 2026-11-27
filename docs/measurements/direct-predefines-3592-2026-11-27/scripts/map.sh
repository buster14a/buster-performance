#!/bin/bash
# map.sh NAME [UNITS...]: bin/compiler-NAME (built with patches/arena-map.patch) compiles each unit, a process each, CPU 2,
# and reports which 4 KB pages of each arena its compile touched, by 2 MB region and by allocation site
# (results/map-NAME-UNIT.txt), with the process's page faults (perf stat). Run under the lock.
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude2
name=$1; shift
bin=$here/bin/compiler-$name
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
L=$here/lua/src
base=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc)
sys=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
musl=(-D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal" "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
tmp=$(mktemp -d /dev/shm/map-3586.XXXXXX)
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
printf '#include <stdio.h>\nint main(void) { printf("hello %%d\\n", 1); return 0; }\n' > "$tmp/hello.c"
printf '#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <stdint.h>\n#include <errno.h>\n#include <unistd.h>\n#include <math.h>\nint main(int argc, char** argv) { char* p = malloc(16); strcpy(p, "x"); printf("%%s %%d %%f\\n", p, argc, sqrt(argc)); free(p); return errno; }\n' > "$tmp/six.c"
units=("$@")
[ ${#units[@]} -eq 0 ] && units=(add hello six wcwidth lparser lvm sqlite)
args_of() {
    case $1 in
        add) echo "${base[@]} -c $tmp/$1.c";;
        hello|six) echo "${base[@]} ${sys[@]} -c $tmp/$1.c";;
        wcwidth) echo "${base[@]} ${musl[@]} -c $M/src/ctype/wcwidth.c";;
        lparser|lvm|lapi|lcode) echo "--lanes 1 -std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $L/$1.c";;
        sqlite) echo "${base[@]} ${sys[@]} -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $C/sqlite/sqlite3.c";;
    esac
}
cat /proc/loadavg
for u in "${units[@]}"; do
    out=$here/results/map-$name-$u.txt
    BUSTER_DIRECT_ARENA_MAP=1 taskset -c 2 "$bin" $(args_of "$u") -o "$tmp/o.o" > "$out" 2>&1
    taskset -c 2 perf stat -x ';' --no-big-num -e page-faults,cycles:k,cycles:u -- "$bin" $(args_of "$u") -o "$tmp/o.o" 2>> "$out" > /dev/null
    echo "== $u: $(grep -E '^arena (arena|scratch)|arena-map' "$out" | tr '\n' ' ') $(grep page-faults "$out" | cut -d';' -f1) faults"
done
rm -rf "$tmp"
