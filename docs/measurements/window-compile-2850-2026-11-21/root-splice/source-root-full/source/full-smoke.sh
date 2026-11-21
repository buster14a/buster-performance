#!/bin/bash
set -eu
ulimit -c 0
d=$(cd "$(dirname "$0")" && pwd)
cc=${COMPACT_COMPILER:-$d/../source-graph-full/build/compiler}
export NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1 NODE_SPLICE_FRONT=1 NODE_SPLICE_REPORT=1
cd "$d/../switch-inputs"; source ../switch-local-args.sh; eval "args=($sqlite_arguments)"
for cfg in default debug; do
 subdir="${COMPACT_RESULTS_ROOT:-$d/full-smoke}/$cfg"; mkdir -p "$subdir"
 opt=(); if [[ $cfg = debug ]]; then opt+=(-g); fi
 for m in original plain operand full; do
  unset NODE_SOURCE_ONLY NODE_SOURCE_COMPACT NODE_SOURCE_COMPACT_FULL NODE_SOURCE_COMPACT_REPORT NODE_SPLICE_ENABLE
  if [[ $m = original ]]; then export NODE_SPLICE_ENABLE=1; fi
  if [[ $m = full || $m = operand ]]; then export NODE_SOURCE_COMPACT=1 NODE_SOURCE_COMPACT_REPORT=1; fi
  if [[ $m = full ]]; then export NODE_SOURCE_COMPACT_FULL=1; fi
  flags=(NODE_SOURCE_NATIVE_ORACLE="$subdir/$m.native" NODE_SOURCE_GRAPH_ORACLE="$subdir/$m.bin"); u=()
  if [[ $cfg = debug && -z "${FIXED_DEBUG_WITNESS:-}" ]]; then flags=(NODE_SOURCE_GRAPH_ORACLE="$subdir/$m.bin"); fi
  if [[ $m = plain ]]; then u=(-u NODE_SPLICE_FRONT -u NODE_PROOF_NO_FP -u NODE_PROOF_POINTERS -u NODE_PROOF_CALLS -u NODE_SOURCE_ROWS -u NODE_PROOF_NATIVE -u NODE_SPLICE_REPORT); fi
  env "${u[@]}" "${flags[@]}" "$cc" --lanes 1 "${opt[@]}" -c "${args[@]}" -o "$subdir/$m.o" >"$subdir/$m.out" 2>"$subdir/$m.err"
 done
 for m in operand full;do
  python "$d/graph_check.py" "$subdir" plain "$m" original > "$subdir/$m.json" || true
  sha256sum "$subdir"/*.o > "$subdir/hashes"
 done
done
