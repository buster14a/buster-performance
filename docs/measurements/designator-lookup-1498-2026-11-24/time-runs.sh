#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
. ./host.sh
args=()
while read -r shape fields rows group; do
    args+=(--list -std=c11 -c "input/$shape.c" -o "input/time-$shape.o")
done < shapes.txt
locked 180 taskset -c 2 head/build/compiler time-runs --runs 24 --warmups 2 \
    --build base base/build/compiler --build head head/build/compiler "${args[@]}" > raw/time-runs.txt
