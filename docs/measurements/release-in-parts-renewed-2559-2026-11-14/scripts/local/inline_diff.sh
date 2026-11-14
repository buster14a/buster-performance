#!/bin/bash
# inline_diff.sh UNIT_BITCODE PARTS PRESPLIT OUT [PRESPLIT_OPTIONS...]: the whole unit's -O3 inlining remarks (cached
# beside the bitcode) and its parts', and the (callee, caller) pairs the whole unit inlines that no part does.
set -u
bc=$1; parts=$2; presplit=$3; out=$4; shift 4
clang=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
jobs=${JOBS:-4}
mkdir -p "$out"
whole_dir=$(dirname "$bc")/$(basename "$bc" .bc).whole
rm -rf "$out/parts"; mkdir -p "$out/parts"
"$presplit" "$bc" "$parts" "$out/parts" "$@" 2> "$out/presplit.log" || { echo presplit failed; tail "$out/presplit.log"; exit 1; }
{
  if [ ! -s "$whole_dir/whole.pairs" ]; then mkdir -p "$whole_dir"; echo "WHOLE $bc $whole_dir"; fi
  for k in $(seq 0 "$parts"); do echo "PART $out/parts/part$k.bc $out/parts/part$k"; done
} | xargs -P "$jobs" -L 1 bash -c '
  if [ "$0" = WHOLE ]; then '"$clang"' -x ir -march=znver5 -fno-stack-protector -O3 -Wno-unused-command-line-argument -c "$1" -o "$2/whole.o" -Rpass=inline -Rpass-missed=inline 2> "$2/whole.remarks";
  else '"$clang"' -x ir -march=znver5 -fno-stack-protector -O3 -Wno-unused-command-line-argument -c "$1" -o "$2.o" -Rpass=inline -Rpass-missed=inline 2> "$2.remarks"; fi'
pairs() { grep -o "'[^']*' inlined into '[^']*'" | sed "s/\.buster_split//g; s/' inlined into '/ /; s/'//g" | sort -u; }
[ -s "$whole_dir/whole.pairs" ] || pairs < "$whole_dir/whole.remarks" > "$whole_dir/whole.pairs"
cp "$whole_dir/whole.pairs" "$out/whole.pairs"
cat "$out"/parts/*.remarks | pairs > "$out/parts.pairs"
comm -23 "$out/whole.pairs" "$out/parts.pairs" > "$out/missing.pairs"
comm -13 "$out/whole.pairs" "$out/parts.pairs" > "$out/extra.pairs"
wc -l "$out/whole.pairs" "$out/parts.pairs" "$out/missing.pairs" "$out/extra.pairs" | head -4 | tr '\n' ' '; echo
