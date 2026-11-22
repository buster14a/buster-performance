#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD;mkdir -p "$d/per-file"
python3 "$d/runtime.py" > "$d/runtime.log" 2>&1 || echo "Runtime outcome needs inspection; see runtime.log"
cd ../switch-inputs;source ../switch-local-args.sh;source_tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$source_tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $source_tree/src/buster/compiler/main.c"
for g in sqlite main lua musl;do v=${g}_arguments;eval "args=(${!v})";python3 "$d/../source-member-operands-study/pair-output.py" "$d/per-file" "$g" "$d/../default-integer-control/build/compiler" "$d/../default-integer-transfers/build/compiler" "${args[@]}";done

cd "$d/../default-integer-transfers"
export PATH=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH
for shard in {1..8};do build/compiler test-checker --seed 2850 --part "$shard/8" >"$d/checker-$shard.log" 2>&1 || exit 1;done
