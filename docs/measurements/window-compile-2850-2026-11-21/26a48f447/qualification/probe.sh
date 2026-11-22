#!/bin/bash
set -eu
export PATH=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH
cd "$(dirname "$0")"
d=$PWD
python3 layout.py
cd ../switch-inputs
source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
for g in sqlite main; do
 key=${g}_arguments
 eval "args=(${!key})"
 gdb -q --batch -x "$d/count-run.gdb" --args "$d/../body-local-emission/build/compiler" --lanes 1 -c "${args[@]}" -o "$d/probe.o" >"$d/count-$g.log" 2>&1
done
