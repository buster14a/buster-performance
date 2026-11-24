#!/bin/bash
# perf record of user instructions, arms 1 (scalar) and 2 (marks v2) of gate2's executable, -E of musl's units, under the lock.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
. ~/buster-fast-bench/2924-asm-pp-claude/env.sh
P=$D/prof; mkdir -p $P
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi; done
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
for m in 1 2; do
    $EX timeout -k 5 200 taskset -c 2 perf record -q -e instructions:u -c 20000 -o $P/arm$m.data $D/gate2/compilers/compiler-areas$m -E "${M[@]}" "${files[@]}" > /dev/null 2> $P/arm$m.err
    perf report -i $P/arm$m.data --no-children --sort sym --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -40 > $P/arm$m.txt
done
echo done > $P/status
