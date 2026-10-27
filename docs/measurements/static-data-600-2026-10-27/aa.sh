#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
taskset -c 2 ./head-final/build/compiler time-runs --runs 15 --warmups 2 --copies 3 --directory "$PWD/copies" \
    --build baseline-A "$PWD/base/build/compiler" --build baseline-B "$PWD/base/build/compiler" \
    --list --lanes 1 -c "$PWD/inputs/writable-1.c" -o "$PWD/objects/current.o"
printf 'AA_OK\n'
