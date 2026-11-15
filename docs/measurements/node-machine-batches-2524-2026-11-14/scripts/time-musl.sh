#!/bin/bash
# time-musl.sh SUFFIX LABEL:BATCH...: the shadow's sweeps timed on musl's 1,336 units (corpora.sh's set and options), 11
# passes, CPU 2, by each LABEL at BATCH ("-": no option), each LABEL:BATCH its own hold of the lock; the files are
# results/LABEL/time-b<BATCH>-musl<SUFFIX>.txt.
set -u
cd "$(dirname "$0")"
suffix=$1
shift
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
options=$(printf '%q ' -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
list=$(printf '%q ' "${files[@]}")
for pair in "$@"; do
    label=${pair%%:*}
    batch=${pair#*:}
    out=$PWD/results/$label
    option=$([ "$batch" = - ] && echo "" || echo "--batch $batch")
    f=$out/time-b$batch-musl$suffix.txt
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner >> $PWD/results/holds-musl$suffix.txt; taskset -c 2 $out/compiler measure-node-machine --shadow --passes 11 $option $options $list > $f 2>&1; echo status \$? >> $f"
done
