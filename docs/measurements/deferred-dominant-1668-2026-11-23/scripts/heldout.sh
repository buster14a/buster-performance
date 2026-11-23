#!/bin/bash
# heldout.sh: buster #1668's held-out dominant-body shapes, made by #447's gen2.c (synthetic/gen2.c) beside its 38 units:
# dN x S f F s C = N bodies of S stanzas, the first of F and the second of C, after stdio.h, stdlib.h and string.h. Chosen
# for the rule's excess over the unit's tokens between 0.30 and 0.60 and 4 lanes or more; none was used to choose the gate.
set -eu
cd ~/buster-fast-bench/1667-claude/synthetic
[ -x gen2 ] || clang -O2 -o gen2 gen2.c
for n in d32x10f768s96 d4x19f768s384 d24x19f768s48 d8x38f512s288 d32x5f384s192 d12x38f192s192 d32x10f384s96 d16x19f256s96 \
         d32x10f192s48 d12x38f256s48 d24x19f384s192 d16x38f384s96 d32x19f256s48 d32x10f96s48 d24x38f768s288; do
    rest=${n:1}
    bodies=${rest%%x*}; rest=${rest#*x}
    stanzas=${rest%%f*}; rest=${rest#*f}
    first=${rest%%s*}; second=${rest#*s}
    ./gen2 "$bodies" "$stanzas" - "$first" "$second" > "$n.c"
done
sha256sum d32x10f768s96.c d4x19f768s384.c d24x19f768s48.c d8x38f512s288.c d32x5f384s192.c d12x38f192s192.c d32x10f384s96.c d16x19f256s96.c \
    d32x10f192s48.c d12x38f256s48.c d24x19f384s192.c d16x38f384s96.c d32x19f256s48.c d32x10f96s48.c d24x38f768s288.c > heldout.sha256
