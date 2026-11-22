#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"; d=$PWD
python3 columns.py
cd ../switch-inputs; source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
for workload in guard sqlite main lua musl; do
 case $workload in
 guard) args=("$d/guard/ordinary.c");;
 lua) args=( "$lua/lvm.c" );;
 musl) eval "all=(${musl_arguments})"; args=(); for arg in "${all[@]}"; do [[ $arg == *.c ]] && break; args+=("$arg"); done; args+=("$musl/src/stdio/vfprintf.c");;
 *) v=${workload}_arguments; eval "args=(${!v})";;
 esac
 for label in base candidate; do
  tree=main-fbef-clean; [[ $label == base ]] || tree=typed-call-signatures
  (cd "$d" && gdb -q --batch -x "$label-columns.gdb" --args "../$tree/build/compiler" --lanes 1 -c "${args[@]}" -o "$d/guard-columns.o") >"$d/$workload-$label-gdb.log" 2>&1
  awk '/^RECEIPT /' "$d/$workload-$label-gdb.log" >"$d/$workload-$label-columns.jsonl"
  test -s "$d/$workload-$label-columns.jsonl"
 done
 cmp "$d/$workload-base-columns.jsonl" "$d/$workload-candidate-columns.jsonl"
done
