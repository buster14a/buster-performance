#!/usr/bin/env bash
# forms.sh: in one lock hold, CPU 2: #2755's hand-written saxpy bodies (saxpy-forms.c, the record's saxpy.c), modes 0
# (Tier 1's legacy body after vzeroupper) and 6 (the same after a dirty vpternlogd), three runs each, perf's user cycles;
# then the Tier 1 programs by base and head, alternating: mix.c (512-bit intrinsics, then scalar float loops) and
# caller.c's two modes (a clang caller clean or dirty before Tier 1's scalar saxpy), five runs each.
set -u
source "$(dirname "$0")/common.sh"
cd $W || exit 1
O=out/forms
mkdir -p $O
$CLANG -O2 -march=znver5 src/saxpy-forms.c -o $O/saxpy-forms || exit 1
for name in base head; do
    C=$W/bin/$name
    $C --tier1 -O2 -march=znver5 src/mix.c -o $O/mix-$name || exit 1
    $C --tier1 -O2 -march=znver5 -c src/kernel.c -o $O/kernel-$name.o || exit 1
    $CLANG -O2 -march=znver5 src/caller.c $O/kernel-$name.o -o $O/caller-$name || exit 1
    $C -S --tier1 -O2 -march=znver5 src/mix.c -o $O/mix-$name.s
    $C -S --tier1 -O2 -march=znver5 src/kernel.c -o $O/kernel-$name.s
done
run()
{
    taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o $O/perf.txt -- "$@" > $O/out.txt 2>&1
    echo "$* | $(cat $O/out.txt | tr '\n' ' ')| cycles $(grep cycles $O/perf.txt | cut -d, -f1) instructions $(grep instructions $O/perf.txt | cut -d, -f1)"
}
$LOCK bash -c "$(declare -f state run); O=$O; state forms
for round in 1 2 3; do run $O/saxpy-forms 0 100000; run $O/saxpy-forms 6 100000; done
for round in 1 2 3 4 5; do
    for name in base head; do run $O/mix-\$name 100000; run $O/caller-\$name 0 200000; run $O/caller-\$name 1 200000; done
done
state forms-end" > $O/results.txt 2>&1
