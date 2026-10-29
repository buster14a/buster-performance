#!/bin/bash
# The effects loop's variants, each benchmark-x86-semantics's unit built alone (x86_semantics_benchmark.c with a main
# that calls it): main (ba379033), main with the index by form number (mainwide), the first head (c2885004, the EVEX
# forms among the rare lanes, counted in a general register), the head and the head with the rare lanes counted in a
# general register (headgpr), and the head with the scalar twin's x87 and vzeroupper resources from a table (headtable).
# One hold builds them; then five holds of a round each run every variant's loop alone (--only effects-avx512), back to
# back and after 200 ms of the scalar twin, and main's, the head's and headtable's scalar twin alone (--only
# effects-scalar), in an order rotating by round.
. "$(dirname "$0")/env.sh"
VD=$B/variants
mkdir -p $M/variants
build() {
    for v in main mainwide old head headgpr headtable; do
        (cd $VD/$v && clang -O3 -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wno-unused-function -Wno-psabi \
            '-DBUSTER_CLANG_DEFAULT_TARGET="x86_64-pc-linux-gnu"' -o sem src/buster/compiler/x86_semantics_benchmark.c ../main.c -lm) ||
            { echo "$v didn't build"; return 1; }
    done
    sha256sum $VD/*/sem
}
round() { # r variants...
    local r=$1
    shift
    for v in "$@"; do
        taskset -c 2 $VD/$v/sem benchmark-x86-semantics --only effects-avx512 > $M/variants/$v-$r.log 2>&1
        taskset -c 2 $VD/$v/sem benchmark-x86-semantics --only effects-avx512 --after-scalar 200 > $M/variants/$v-after-$r.log 2>&1
        case $v in
        main | head | headtable) taskset -c 2 $VD/$v/sem benchmark-x86-semantics --only effects-scalar > $M/variants/$v-scalar-$r.log 2>&1 ;;
        esac
    done
}
export -f build round
$X bash -c ". $B/env.sh; VD=$VD; build" || exit 1
orders=("main mainwide old head headgpr headtable" "headtable main mainwide old head headgpr" "headgpr headtable main mainwide old head"
    "head headgpr headtable main mainwide old" "old head headgpr headtable main mainwide")
for r in 1 2 3 4 5; do
    $X bash -c ". $B/env.sh; VD=$VD; round $r ${orders[$((r - 1))]}"
done
echo "variants done $(date -Is)"
