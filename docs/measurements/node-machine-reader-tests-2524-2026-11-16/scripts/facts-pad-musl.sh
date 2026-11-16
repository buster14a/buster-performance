#!/bin/bash
# facts-pad-musl.sh LABEL TAG PAD [shadow options]: facts-pad.sh on musl's 1,336 units: measure-node-machine --shadow
# --facts [options] by results/LABEL/compiler, CPU 2, one hold of the lock, with no address-space randomization
# (setarch -R) and an environment variable of PAD bytes, which moves the stack down by as much. File
# results/LABEL/padmusl-TAG-PAD.txt.
set -u
cd "$(dirname "$0")"
label=$1; tag=$2; pad=$3
shift 3
options="$*"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C
out=$PWD/results/$label
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
moptions=$(printf '%q ' -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
list=$(printf '%q ' "${files[@]}")
filler=$(head -c $pad /dev/zero | tr '\0' x)
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; BUSTER_STACK_PAD=$filler setarch x86_64 -R taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options $moptions $list; echo status \$?" > $out/padmusl-$tag-$pad.txt 2>&1
