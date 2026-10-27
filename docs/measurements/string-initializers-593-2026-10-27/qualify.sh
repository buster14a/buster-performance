#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if test -f STOP_OLD_CAMPAIGN; then exit 77; fi
kind=$1
id=$2
n=$3
file="$(pwd)/inputs/$kind-$n.c"
for version in base head; do
    "../$version/build/compiler" --verify -c "$file" -o "objects/$kind-$n-$version.o"
done
cmp "objects/$kind-$n-base.o" "objects/$kind-$n-head.o"
tcc -c "$file" -o "objects/$kind-$n-tcc.o"
for version in base head tcc; do
    clang -O0 -DKIND="$id" verify.c "objects/$kind-$n-$version.o" -o "objects/$kind-$n-$version"
    "objects/$kind-$n-$version" "$n"
done
sha256sum "objects/$kind-$n-"*.o
echo "qualification kind=$kind count=$n byte_identical=1 status=0"
