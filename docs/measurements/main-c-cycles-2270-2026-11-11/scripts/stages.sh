#!/usr/bin/env bash
# --time-stages of main.c -c on CPU 2, each build once, order alternating; one round per call. Usage: stages.sh OUTDIR ROUND NAME=EXE...
set -u
W=$HOME/buster-fast-bench/2270-claude
out=$1; r=$2; shift 2
mkdir -p "$out"
src=$W/head/src
args=(-c --time-stages -march=native -I"$src" -fwrapv -funsigned-char "$src/buster/compiler/main.c" -o /dev/null)
list=("$@"); if (( r % 2 == 0 )); then list=($(printf '%s\n' "$@" | tac)); fi
for b in "${list[@]}"; do
  name=${b%%=*}; exe=${b#*=}
  taskset -c 2 "$exe" "${args[@]}" > /dev/null 2> "$out/$name.$r.txt" || echo "fail $name $r" >&2
done
