#!/bin/bash
# whole.sh UNIT: the whole unit's -O3 remarks and pairs, cached beside its bitcode.
u=$1; d=/root/.cache/claude-2559/bc/$u.whole; mkdir -p $d
/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang -x ir -march=znver5 -fno-stack-protector -O3 -Wno-unused-command-line-argument -c /root/.cache/claude-2559/bc/$u.bc -o $d/whole.o -Rpass=inline -Rpass-missed=inline 2> $d/whole.remarks.tmp && mv $d/whole.remarks.tmp $d/whole.remarks && grep -o "'[^']*' inlined into '[^']*'" $d/whole.remarks | sed "s/\.buster_split//g; s/' inlined into '/ /; s/'//g" | sort -u > $d/whole.pairs.tmp && mv $d/whole.pairs.tmp $d/whole.pairs
