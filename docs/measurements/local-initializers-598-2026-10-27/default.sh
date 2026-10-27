#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p logs-default
for stem in string-128 string-512 list-32 list-512 list-40000; do
    ./compile ../base/build/compiler ../head/build/compiler "cases/$stem.c" "${stem%-*}" "${stem##*-}" logs-default default
    for variant in base head; do
        if test -f "logs/$variant-$stem.o" && test -f "logs-default/$variant-$stem.o"; then
            cmp "logs/$variant-$stem.o" "logs-default/$variant-$stem.o"
        fi
    done
done
