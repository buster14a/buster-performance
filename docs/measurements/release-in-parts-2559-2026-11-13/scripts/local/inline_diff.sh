#!/bin/bash
# inline_diff.sh UNIT_BITCODE PARTS PRESPLIT OUT [PRESPLIT_OPTIONS...]: the inlining remarks of the whole unit's -O3 and of
# its parts' (split by PRESPLIT), and the (callee, caller) pairs the whole unit inlines that no part does.
set -u
bc=$1; parts=$2; presplit=$3; out=$4; shift 4
clang=/usr/lib/llvm-23/bin/clang
mkdir -p "$out/parts"
$clang -x ir -march=native -fno-stack-protector -O3 -Wno-unused-command-line-argument -c "$bc" -o "$out/whole.o" -Rpass=inline 2> "$out/whole.remarks" &
rm -rf "$out/parts"; mkdir -p "$out/parts"
"$presplit" "$bc" "$parts" "$out/parts" "$@" 2> "$out/presplit.log"
for k in $(seq 0 "$parts"); do
    $clang -x ir -march=native -fno-stack-protector -O3 -Wno-unused-command-line-argument -c "$out/parts/part$k.bc" -o "$out/parts/part$k.o" -Rpass=inline 2> "$out/parts/part$k.remarks" &
done
wait
pairs() { grep -o "'[^']*' inlined into '[^']*'" | sed "s/\.buster_split//g; s/' inlined into '/ /; s/'//g" | sort -u; }
pairs < "$out/whole.remarks" > "$out/whole.pairs"
cat "$out"/parts/*.remarks | pairs > "$out/parts.pairs"
comm -23 "$out/whole.pairs" "$out/parts.pairs" > "$out/missing.pairs"
wc -l "$out/whole.pairs" "$out/parts.pairs" "$out/missing.pairs"
