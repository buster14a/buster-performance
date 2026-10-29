#!/bin/bash
# The final head's effects loop (final: ecb3fcfd) against a variant whose records with an opmask are rare lanes too
# (finalmask: their bits join the rare lanes' register, and `known` loses its vptestnmq), each benchmark unit built
# alone as variants.sh builds them: one hold builds both, then five holds of a round each run both loops alone, back to
# back and after 200 ms of the scalar twin, in an order alternating by round.
. "$(dirname "$0")/env.sh"
VD=$B/variants
mkdir -p $M/variants2
build() {
    for v in final finalmask; do
        (cd $VD/$v && clang -O3 -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wno-unused-function -Wno-psabi \
            '-DBUSTER_CLANG_DEFAULT_TARGET="x86_64-pc-linux-gnu"' -o sem src/buster/compiler/x86_semantics_benchmark.c ../main.c -lm) ||
            { echo "$v didn't build"; return 1; }
    done
    sha256sum $VD/final/sem $VD/finalmask/sem
}
round() { # r variants...
    local r=$1
    shift
    for v in "$@"; do
        taskset -c 2 $VD/$v/sem benchmark-x86-semantics --only effects-avx512 > $M/variants2/$v-$r.log 2>&1
        taskset -c 2 $VD/$v/sem benchmark-x86-semantics --only effects-avx512 --after-scalar 200 > $M/variants2/$v-after-$r.log 2>&1
    done
}
export -f build round
$X bash -c ". $B/env.sh; VD=$VD; build" || exit 1
for r in 1 2 3 4 5; do
    if [ $((r % 2)) -eq 1 ]; then $X bash -c ". $B/env.sh; VD=$VD; round $r final finalmask"; else $X bash -c ". $B/env.sh; VD=$VD; round $r finalmask final"; fi
done
echo "variants2 done $(date -Is)"
