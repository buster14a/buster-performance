#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
printf 'unsigned char zero[67108864] = {0};\n' > inputs/zero-control.c
for variant in base head-final; do
    taskset -c 2 "./$variant/build/compiler" --lanes 1 -c "$PWD/inputs/zero-control.c" -o "objects/zero-$variant.o"
done
cmp objects/zero-base.o objects/zero-head-final.o
readelf -SW objects/zero-head-final.o
taskset -c 2 ./head-final/build/compiler time-runs --runs 9 --warmups 2 --copies 2 --directory "$PWD/copies" \
    --build base "$PWD/base/build/compiler" --build head "$PWD/head-final/build/compiler" \
    --list --lanes 1 -c "$PWD/inputs/zero-control.c" -o "$PWD/objects/current.o"
printf 'ZERO_CONTROL_OK\n'
