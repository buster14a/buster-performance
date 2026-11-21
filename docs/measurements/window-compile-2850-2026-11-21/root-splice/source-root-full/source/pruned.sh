#!/bin/bash
set -eu
d=$(cd "$(dirname "$0")" && pwd); cc=${COMPACT_COMPILER:-$d/../source-graph-full/build/compiler}
cd "$d/../switch-inputs"; source ../switch-local-args.sh;eval "args=($sqlite_arguments)"
dir="$d/pruned";mkdir -p "$dir"
cp "$d/combined/default/plain.bin" "$dir/plain.bin";cp "$d/combined/default/plain.err" "$dir/plain.err";cp "$d/smoke/sqlite/original.err" "$dir/original.err"
export NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_PROOF_NATIVE=1 NODE_SPLICE_FRONT=1 NODE_SOURCE_ROWS=1 NODE_SPLICE_REPORT=1 NODE_SOURCE_COMPACT_REPORT=1 NODE_SOURCE_COMPACT=1 NODE_SOURCE_COMPACT_FULL=1 NODE_SOURCE_COMPACT_READS=1 NODE_SOURCE_LOCAL_ACCESS=1 NODE_SOURCE_REFRESH_POINTERS=1 NODE_SOURCE_STRINGS=1
for m in normal pruned straight external; do
 unset NODE_SOURCE_PRUNED_GUARDS NODE_SOURCE_STRAIGHT_GUARDS NODE_SOURCE_EXTERNAL_BODY
 case "$m" in pruned)export NODE_SOURCE_PRUNED_GUARDS=1;;straight)export NODE_SOURCE_STRAIGHT_GUARDS=1;;external)export NODE_SOURCE_PRUNED_GUARDS=1 NODE_SOURCE_EXTERNAL_BODY=1;;esac
 NODE_SOURCE_GRAPH_ORACLE="$dir/$m.bin" NODE_SOURCE_NATIVE_ORACLE="$dir/$m.native" "$cc" --lanes 1 -c "${args[@]}" -o "$dir/$m.o" > "$dir/$m.out" 2> "$dir/$m.err"
 python "$d/graph_check.py" "$dir" plain "$m" original > "$dir/$m.json"
 cmp "$dir/$m.o" "$d/combined/default/plain.o";cmp "$dir/$m.native" "$d/combined/default/plain.native"
done
