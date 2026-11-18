#!/bin/bash
# #2963: -g objects of base and head compared, each compiled in one fixed directory (/dev/shm/claude-2963/cur, moved
# aside after), since -g records the directory: run.sh compiled them in different ones and all 1,370 differed.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2963 EXCLUSIVE_TITLE="Tier 1 code certificate: musl's full barrier (#2963)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2963
L=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$HOME/buster-fast-bench/claude-linker-80/inputs/lua-5.4.8/src
export LC_ALL=C
status=logs/status-g.txt
: > "$status"
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
muslflags=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
objects=/dev/shm/claude-2963
rm -rf "$objects"
for tree in base head; do
    out=$objects/cur
    err=$D/logs/stderr-g2-$tree.txt
    mkdir -p "$out/sqlite" "$out/lua" "$out/musl"
    : > "$err"
    $L timeout -k 5 1500 bash -c '
        exe=$1; out=$2; err=$3; sqlite=$4; lua=$5; shift 5
        (cd "$out/sqlite" && "$exe" -c --tier1 -g --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o sqlite3.o > /dev/null 2>>"$err"); echo "sqlite $?"
        (cd "$out/lua" && "$exe" -c --tier1 -g --lanes 1 "$lua"/*.c > /dev/null 2>>"$err"); echo "lua $?"
        (cd "$out/musl" && "$exe" -c --tier1 -g --lanes 1 "$@" > /dev/null 2>>"$err"); echo "musl $?"
    ' run "$D/compiler-$tree" "$out" "$err" "$sqlite" "$lua" "${muslflags[@]}" "${files[@]}" > "logs/objects-g2-$tree.log" 2>&1
    echo "$tree g: $(grep -v exclusive.sh logs/objects-g2-$tree.log | tr '\n' ' ') $(grep -c 'error:' "$err") error lines, $(find "$out" -name '*.o' | wc -l) objects" >> "$status"
    mv "$out" "$objects/$tree"
done
n=0; d=0
: > logs/objects-g2-compare.txt
while read -r f; do
    n=$((n+1))
    if [[ ! -f $objects/head/$f ]]; then echo "missing in head: $f" >> logs/objects-g2-compare.txt; continue; fi
    cmp -s "$objects/base/$f" "$objects/head/$f" || { d=$((d+1)); echo "differs: $f" >> logs/objects-g2-compare.txt; }
done < <(cd "$objects/base" && find . -name '*.o' | sort)
echo "objects g: $n of base's compared, $d differ; head has $(cd "$objects/head" && find . -name '*.o' | wc -l)" >> "$status"
rm -rf "$objects"
date -u +%FT%TZ > logs/.done-g
