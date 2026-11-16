#!/bin/bash
# facts-gdb-musl.sh LABEL TAG [shadow options]: the fact words' harness on musl's 1,336 units by results/LABEL/compiler
# under gdb (no address-space randomization, CPU 2, one hold of the lock), stopped at its report, to read what it keeps
# and doesn't print: the second pass's TSC ticks (the windows' given records put in place alone) beside its cycles, and
# the first pass's. File results/LABEL/gdbmusl-TAG.txt.
set -u
cd "$(dirname "$0")"
label=$1; tag=$2
shift 2
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
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; taskset -c 2 gdb -q -batch -ex 'break node_shadow_facts_report' -ex run -ex 'printf \"gdb: records=%lu taken-leaves=%lu taken-lookups=%lu pass-cycles=%lu pass-instructions=%lu pass-ticks=%lu given-cycles=%lu given-instructions=%lu given-ticks=%lu\\n\", shadow->facts_records, shadow->facts_taken_leaves, shadow->facts_taken_lookups, shadow->facts_cycles, shadow->facts_instructions, shadow->facts_ticks, shadow->facts_given_cycles, shadow->facts_given_instructions, shadow->facts_given_ticks' -ex continue --args $out/compiler measure-node-machine --shadow --facts $options $moptions $list; echo status \$?" 2>&1 | grep -v 'node-census: list\|given op=' > $out/gdbmusl-$tag.txt
