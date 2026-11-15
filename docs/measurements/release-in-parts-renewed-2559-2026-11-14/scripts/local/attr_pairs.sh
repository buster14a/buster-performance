#!/bin/bash
# attr_pairs.sh UNIT PARTS_DIR OUT ATTR_SOURCE_LL: the parts of PARTS_DIR with ATTR_SOURCE_LL's function attributes on their
# declarations and available_externally bodies (tools/oracle_attrs2.py), compiled with inlining remarks; the pairs the
# whole unit inlines and they don't.
set -u
unit=$1; parts=$2; out=$3; source=$4
c=~/.cache/claude-2559
clang=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
mkdir -p "$out"
for f in "$parts"/part*.bc; do
    b=$(basename "$f" .bc)
    echo "$clang -x ir -O3 -Xclang -disable-llvm-passes -Wno-unused-command-line-argument -S -emit-llvm $f -o $out/$b.raw.ll && python3 $c/tools/oracle_attrs2.py $source $out/$b.raw.ll $out/$b.in.ll > /dev/null && $clang -x ir -march=znver5 -fno-stack-protector -O3 -Wno-unused-command-line-argument -c $out/$b.in.ll -o $out/$b.o -Rpass=inline -Rpass-missed=inline 2> $out/$b.remarks"
done > "$out/cmds.txt"
xargs -P 4 -I{} bash -c '{}' < "$out/cmds.txt"
pairs() { grep -o "'[^']*' inlined into '[^']*'" | sed "s/\.buster_split//g; s/' inlined into '/ /; s/'//g" | sort -u; }
cat "$out"/*.remarks | pairs > "$out/parts.pairs"
comm -23 "$c/bc/p/$unit.whole/whole.pairs" "$out/parts.pairs" > "$out/missing.pairs"
comm -13 "$c/bc/p/$unit.whole/whole.pairs" "$out/parts.pairs" > "$out/extra.pairs"
wc -l "$out/missing.pairs" "$out/extra.pairs" | head -2
