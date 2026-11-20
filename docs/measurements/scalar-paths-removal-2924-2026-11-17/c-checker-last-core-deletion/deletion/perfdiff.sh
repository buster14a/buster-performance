#!/bin/bash
# Instructions by function, base against head: perf record -e instructions:u (period 100003) of -c --lanes 1 -Wall
# -Wextra of musl's units and of Lua's units, each build three times; perf report by symbol, summed.
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's last twins, C12c-3 core-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
lua=$D/../c3pr/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
out=/dev/shm/claude-2924-c12c33p; rm -rf "$out"; mkdir -p "$out" logs/perf
for list in musl lua; do
    case $list in musl) args=("${M[@]}" "${files[@]}");; lua) args=("$lua"/*.c);; esac
    for b in base head; do
        for i in 1 2 3; do
            (cd "$out" && $L taskset -c 2 perf record -q -e instructions:u -c 100003 -o "$out/$list-$b-$i.data" -- "$D/compilers/$b" -c --lanes 1 -Wall -Wextra "${args[@]}" > /dev/null 2>&1)
            perf report -q -i "$out/$list-$b-$i.data" --stdio --sort symbol -F sample,symbol 2>/dev/null > "logs/perf/$list-$b-$i.txt"
            rm -f "$out/$list-$b-$i.data"
        done
    done
done
rm -rf "$out"
echo done > logs/perf/status.txt
