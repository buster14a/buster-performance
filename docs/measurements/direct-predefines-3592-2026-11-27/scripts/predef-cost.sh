#!/bin/bash
# predef-cost.sh NAME N: perf stat over N compiles of a one-function unit, CPU 2: with the corpus's pinned predefines,
# with an empty predefines file, and the product's own (no --predefines). Per compile.
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude2
name=$1; n=$2
bin=$here/bin/compiler-$name
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
tmp=$(mktemp -d /dev/shm/pdc-3586.XXXXXX)
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
: > "$tmp/empty.h"
printf '#!/bin/bash\nfor ((i = 0; i < %d; i++)); do "$@"; done\n' "$n" > "$tmp/loop.sh"; chmod +x "$tmp/loop.sh"
wc -l "$C/provenance/gnu17-pinned-predefines.txt"
for v in pinned empty product version; do
    case $v in
        pinned) a=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" -c "$tmp/add.c" -o "$tmp/o.o");;
        empty) a=(--lanes 1 --predefines "$tmp/empty.h" -c "$tmp/add.c" -o "$tmp/o.o");;
        product) a=(--lanes 1 -c "$tmp/add.c" -o "$tmp/o.o");;
        version) a=(--version);;
    esac
    taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$tmp/$v.csv" -- "$tmp/loop.sh" "$bin" "${a[@]}" > /dev/null 2>&1
    printf '%-8s' "$v"; awk -F';' -v n="$n" '/^[0-9]/ { printf " %s %.4g", $3, $1 / n }' "$tmp/$v.csv"; echo
done
rm -rf "$tmp"
