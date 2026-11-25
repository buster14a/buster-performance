#!/bin/bash
set -euo pipefail
scripts=$(cd -- "$(dirname -- "$0")" && pwd)
cd "${1:?pass the workspace containing bin, inputs and corpus}"
w=$PWD
C=$w/corpus
M=$C/libc/musl
D=$(mktemp -d /tmp/buster-direct-compare.XXXXXX)
mkdir -p logs
printf '%s\n' "$D" > objects.dir
tags=(compBASE comp3589 comp3590 comp3591 compSAFE)
flags=(--lanes 1 --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -c --predefines "$C/provenance/gnu17-pinned-predefines.txt")
sql=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
     -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
printf 'workload\tround\tslot\tbuild\twall_ms\tuser_us\tsystem_us\tmaxrss_kib\tminor_faults\tmajor_faults\n' > times.tsv
printf 'workload\tbuild\tpath\tsha256\n' > objects.tsv
order=(0 1 4 2 3)
trial=("$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 40 taskset -c 2 bash "$scripts/sample.sh")
for name in semantics sqlite-fresh sqlite-rewrite tables inline switch locals unsigned; do
    echo "$name"
    case $name in
        sqlite-*) args=("${sql[@]}");;
        tables) args=("-I$M/src/locale" "$w/inputs/tables.c");;
        inline) args=("$w/inputs/chain4000.c");;
        switch|unsigned|semantics) args=("$w/inputs/$name.c");;
        locals) args=("$w/inputs/locals2000.c");;
    esac
    for tag in "${tags[@]}"; do
        "${trial[@]}" verify "$name" "$tag" 0 0 "$D" "${flags[@]}" "${args[@]}" >> logs/scheduling.log 2>&1
    done
    if [[ $name == semantics ]]; then continue; fi
    for ((round=-10;round<60;++round)); do
        row=$(((round+10)%10))
        for slot in 0 1 2 3 4; do
            pos=$slot
            if ((row>=5)); then pos=$((4-slot)); fi
            v=$(((order[pos]+row)%5))
            "${trial[@]}" time "$name" "${tags[v]}" "$round" "$slot" "$D" "${flags[@]}" "${args[@]}" >> logs/scheduling.log 2>&1
        done
    done
done
