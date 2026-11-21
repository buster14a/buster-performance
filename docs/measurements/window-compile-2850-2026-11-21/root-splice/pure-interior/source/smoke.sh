#!/bin/bash
set -eu
ulimit -c 0
d=$(cd "$(dirname "$0")" && pwd)
rev=$1;cc=$d/$rev-compiler;cd "$d/../switch-inputs";source ../switch-local-args.sh
for policy in plain debug wall;do
  flags=()
  case $policy in debug)flags=(-g);;wall)flags=(-Wall -Wextra);;esac
  for corpus in fixture sqlite;do
    args=("$d/fixture.c");[[ $corpus != sqlite ]] || eval "args=($sqlite_arguments)"
    out="$d/$rev/$corpus-$policy";mkdir -p "$out"
    for mode in plain source;do
      envs=();[[ $mode = plain ]] || envs+=(NODE_PURE_INTERIOR=1 NODE_PURE_INTERIOR_REPORT=1)
      env "${envs[@]}" NODE_SOURCE_GRAPH_ORACLE="$out/$mode.bin" NODE_SOURCE_NATIVE_ORACLE="$out/$mode.native" "$cc" --lanes 1 -c "${flags[@]}" "${args[@]}" -o "$out/$mode.o" >"$out/$mode.out" 2>"$out/$mode.err" || true
      sed '/^interior-taken:/d' "$out/$mode.err" > "$out/$mode.diagnostic"
    done
    for ext in diagnostic o native;do if cmp -s "$out/plain.$ext" "$out/source.$ext";then echo "$corpus $policy $ext match";else echo "$corpus $policy $ext DIFFERENT";fi;done
    if [[ -f $out/source.bin ]];then python "$d/verify.py" "$out" >"$out/graph.json"; grep -E 'source_roots|removed|mismatches' "$out/graph.json";fi
  done
done
