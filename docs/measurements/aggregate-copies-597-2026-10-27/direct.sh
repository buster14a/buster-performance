#!/usr/bin/env bash
# One direct/object-output regression run; invoke under exclusive.sh on the target host.
set -euo pipefail
compiler=$1
mkdir -p tmp
for scalar in vector scalar; do
    twin=()
    if [ "$scalar" = scalar ]; then twin=(--scalar); fi
    "$compiler" --lanes 1 --verify "${twin[@]}" direct.c -o "tmp/direct-$scalar"
    "tmp/direct-$scalar"
    printf 'direct scalar=%s mode=native status=0\n' "$scalar"
    "$compiler" --lanes 1 --verify "${twin[@]}" -c direct.c -o "tmp/direct-$scalar.o"
    clang "tmp/direct-$scalar.o" -o "tmp/external-$scalar"
    "tmp/external-$scalar"
    printf 'direct scalar=%s mode=external-object status=0\n' "$scalar"
done
