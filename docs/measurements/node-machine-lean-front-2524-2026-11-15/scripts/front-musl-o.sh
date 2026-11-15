#!/bin/bash
# front-musl-o.sh SUFFIX RUNS SPEC...: as front-o.sh on musl's 1,336 units (corpora.sh's set and options), each run of each
# SPEC its own hold of the lock. Files results/LABEL/front-TAG-musl<SUFFIX>-N.txt.
set -u
cd "$(dirname "$0")"
suffix=$1; runs=$2
shift 2
specs=("$@")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
moptions=$(printf '%q ' -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
list=$(printf '%q ' "${files[@]}")
for n in $(seq 1 $runs); do
    for spec in "${specs[@]}"; do
        set -- $spec
        label=$1; tag=$2; shift 2
        options="$*"
        out=$PWD/results/$label
        f=$out/front-$tag-musl$suffix-$n.txt
        ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-front-musl$suffix.txt; taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 $options $moptions $list > $f 2>&1; echo status \$? >> $f"
    done
done
