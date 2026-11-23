#!/bin/bash
# lbr-train.sh TREE NAME WORKLOAD...: branch-stack profiles (perf record -j any,u, one sample each 20,011 user cycles)
# of the tree's compiler on the workloads (main, lua, musl, sqlite: pair2.sh's arguments), each run one hold of the
# lock on CPU 2, reduced to results/lbr-NAME/preagg.txt in BOLT's pre-aggregated form.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
tree=$1; name=$2; shift 2
cc="$dir/trees/$tree/build/compiler"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$dir/inputs/lua-5.4.8/src
out="$dir/results/lbr-$name"
rm -rf "$out"; mkdir -p "$out/scratch"
export LC_ALL=C
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: branch profile of the compiler, $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
for workload in "$@"; do
    case $workload in
        sqlite) args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o unit.o);;
        main) args=(-march=native "-I$dir/inputs/pooled-main-source/src" -fwrapv -funsigned-char --predefines "$dir/inputs/proof-predefines.h" "$dir/inputs/pooled-main-source/src/buster/compiler/main.c" -o unit.o);;
        lua) args=("$lua"/*.c);;
        musl)
            files=()
            declare -A seen
            for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
                b=${f##*/}
                if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
            done
            args=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}");;
    esac
    (cd "$out/scratch" && "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 perf record -q -e cycles:u -j any,u -c 20011 -o "$out/$workload.data" -- "$cc" --lanes 1 -c "${args[@]}" > /dev/null 2> "$out/$workload.stderr") 2>> "$out/lock.log" || echo "$workload: status $?" >> "$out/failed"
    rm -f "$out/scratch"/*.o
done
rm -rf "$out/scratch"
text=$(readelf -lW "$cc" | awk '$1 == "LOAD" && $7 == "R" && $8 == "E" { print $3, $6 }')
low=$(echo "$text" | cut -d' ' -f1); size=$(echo "$text" | cut -d' ' -f2)
high=$(printf '0x%x' $((low + size)))
echo "text $low $high" > "$out/text.txt"
for workload in "$@"; do perf script -i "$out/$workload.data" -F brstack 2> /dev/null; done | python3 "$dir/preagg.py" "$low" "$high" > "$out/preagg.txt" 2> "$out/preagg.log"
rm -f "$out"/*.data
cat "$out/preagg.log"
echo done > "$out/complete"
