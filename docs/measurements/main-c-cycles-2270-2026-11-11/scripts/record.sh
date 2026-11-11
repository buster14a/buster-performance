#!/usr/bin/env bash
# perf record (user cycles, fixed period) of main.c -c on CPU 2, each build once; one round per call. Usage: record.sh OUTDIR ROUND NAME=EXE...
set -u
W=$HOME/buster-fast-bench/2270-claude
out=$1; r=$2; shift 2
mkdir -p "$out"
src=$W/head/src
args=(-c -march=native -I"$src" -fwrapv -funsigned-char "$src/buster/compiler/main.c" -o /dev/null)
for b in "$@"; do
  name=${b%%=*}; exe=${b#*=}
  perf record -q -e cycles:u -c 200003 -o "$out/$name.$r.data" taskset -c 2 "$exe" "${args[@]}" > /dev/null 2>&1 || echo "fail $name $r" >&2
done
