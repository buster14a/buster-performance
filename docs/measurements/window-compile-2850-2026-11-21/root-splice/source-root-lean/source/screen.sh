#!/bin/bash
set -eu
ulimit -c 0
d=$(cd "$(dirname "$0")" && pwd)
prev="$d/../source-graph-study/7ef990068-compiler"; cc=${COMPILER:-$d/../source-lean-driver/build/compiler};res="$d/${1:?use a revision name}"
mkdir -p "$res"
cd "$d/../switch-inputs"
source ../switch-local-args.sh
eval "args=($sqlite_arguments)"
for m in parent plain source dry;do
  opt=();bin=$cc; envs=()
  case "$m" in parent)bin=$prev;;source)opt+=(--node-window-source);;dry)opt+=(--node-window-source);envs+=(NODE_SOURCE_COMPACT_DRY=1);;esac
  env "${envs[@]}" NODE_SOURCE_NATIVE_ORACLE="$res/$m.native" NODE_SOURCE_GRAPH_ORACLE="$res/$m.bin" NODE_SOURCE_COMPACT_REPORT=1 NODE_SPLICE_REPORT=1 "$bin" --lanes 1 "${opt[@]}" -c "${args[@]}" -o "$res/$m.o" >"$res/$m.out" 2>"$res/$m.err"
  cmp "$res/parent.o" "$res/$m.o"
  cmp "$res/parent.native" "$res/$m.native"
done
cp "$d/../source-graph-study/smoke/sqlite/original.err" "$res/original.err"
python "$d/../source-graph-study/graph_check.py" "$res" plain source original > "$res/graph.json"
rg -c '^compact-(taken|consumed):' "$res/source.err"
python "$d/paired.py" "$cc" "$prev" "$res/perf" "${args[@]}" > "$res/perf-summary.json"
