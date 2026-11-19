#!/bin/bash
# Instructions of -E of the first N of musl's units (base and head), and of one header-heavy unit alone, perf stat.
set -uo pipefail
D=~/buster-fast-bench/2924-c-df-claude/c12apr
cd $D
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the preprocessor, C12a" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
mkdir -p units
for n in 1 2 10 100 400; do
    for side in base head; do
        cp compilers/$side units/exe
        $L timeout -k 5 600 taskset -c 2 perf stat -x, -e instructions:u -o units/$side-$n.csv ./units/exe -E "${M[@]}" "${files[@]:0:$n}" > /dev/null 2>> units/stderr.txt
        echo "$side $n: $?" >> units/status.txt
        rm -f units/exe
    done
done
echo "files ${#files[@]}" >> units/status.txt
echo done >> units/status.txt
