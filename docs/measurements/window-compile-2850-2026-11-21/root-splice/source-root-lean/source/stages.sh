#!/bin/bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);rev=$1;cc="$d/$rev-compiler"; mkdir -p "$d/$rev/stages"
cd "$d/../switch-inputs"; source ../switch-local-args.sh;eval "args=($sqlite_arguments)"
for mode in plain source;do flags=();[[ $mode = plain ]] || flags+=(--node-window-source)
 "$cc" --time-stages --lanes 1 "${flags[@]}" -c "${args[@]}" -o "$d/$rev/stages/$mode.o" >"$d/$rev/stages/$mode.out" 2>"$d/$rev/stages/$mode.err"
done
cmp "$d/$rev/stages/"{plain,source}.o
