#!/bin/bash
# #2924 C11: the relaxation's arms alone. One experiment executable (main 0c113feb1 plus c11-relax-knob.patch:
# BUSTER_ASM_RELAX_SCALAR=1 sends asm_relax_first and asm_relax_place to their scalar arms, everything else stays on the
# vector path) runs benchmark-assembler --only vector with the knob off and on, alternately, four rounds, every run under
# the lock on CPU 2, on the gate's three real inputs and two synthetic workloads at 2,048 functions.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the assembler's relaxation arms" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p relax
if [ ! -d src-knob ]; then git clone -q --shared $D/../c7gate/src src-knob || exit 1; fi
git -C src-knob fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> relax/status.txt; exit 1; }
git -C src-knob checkout -q --detach 0c113feb1 && git -C src-knob reset -q --hard
git -C src-knob apply "$D/c11-relax-knob.patch" || { echo "patch failed" >> relax/status.txt; exit 1; }
(cd src-knob && $L timeout -k 5 1500 ./build.sh --config Release > "$D/relax/build.log" 2>&1) || { echo "build failed" >> relax/status.txt; exit 1; }
cp src-knob/build/compiler compiler-knob
for round in 1 2 3 4; do
    for knob in 0 1; do
        for input in sqlite3-gcc sqlite3-clang-intel lvm-clang; do
            BUSTER_ASM_RELAX_SCALAR=$knob $L timeout -k 5 900 taskset -c 2 ./compiler-knob benchmark-assembler --only vector --input "inputs/$input.s" > "relax/$input-knob$knob-round$round.log" 2>&1
            echo "$input knob$knob round$round: $?" >> relax/status.txt
        done
        for workload in mixed att; do
            BUSTER_ASM_RELAX_SCALAR=$knob $L timeout -k 5 900 taskset -c 2 ./compiler-knob benchmark-assembler --only vector --workload "$workload" --functions 2048 > "relax/$workload-knob$knob-round$round.log" 2>&1
            echo "$workload knob$knob round$round: $?" >> relax/status.txt
        done
    done
done
echo done >> relax/status.txt
