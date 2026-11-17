#!/bin/bash
# The kernels by MAIN's and HEAD's --tier1 and clang -O2 (no vectorizers), each linked with one clang -O2 driver, in the
# current directory; each kernel's address and its offset in a 64-byte line; the inputs' and outputs' hashes.
# Usage: kernels-build.sh MAIN HEAD
set -e
clang -O2 -c -o driver.o driver.c
"$1" -c --tier1 --tier1-strict -o m1.o kernels.c
"$2" -c --tier1 --tier1-strict -o h1.o kernels.c
clang -O2 -fno-vectorize -fno-slp-vectorize -c -o c2.o kernels.c
for v in m1 h1 c2; do
    clang -o $v driver.o $v.o
    objdump -d --no-show-raw-insn $v.o > $v.s
    nm $v | grep ' T k_' | while read -r address kind name; do
        echo "address $v $name 0x$address line-offset $(( 0x$address % 64 ))"
    done
done
sha256sum "$1" "$2" m1.o h1.o c2.o driver.o kernels.c driver.c
