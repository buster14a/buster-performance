#!/bin/bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
work=$PWD
source "$work/owner.sh"
test "$(cat campaign-status)" = $'done\t0'
mkdir -p confirm/bin confirm/raw
cd confirm
trap 's=$?; printf "%s\t%d\n" "$stage" "$s" > status' EXIT
stage=setup
lock=$HOME/buster-fast-bench/exclusive.sh
outdir=$(mktemp -d /tmp/buster-direct-confirm.XXXXXX)
printf '%s\n' "$outdir" > raw/output-directory.txt
ln -s "$work/bin/time-one" bin/time-one
for name in base9700 head9700 controlA controlB; do
    target=baseline
    if [[ $name == head9700 ]]; then target=candidate; fi
    ln "$work/bin/$target" "bin/$name"
    ln -s "$work/four-workers.sh" "bin/$name-four"
done
C=$work/corpus
M=$C/libc/musl
flags=(--lanes 1 --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -c --predefines "$C/provenance/gnu17-pinned-predefines.txt")
sqlite=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
        -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
musl=(-D_XOPEN_SOURCE=700 "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal"
      "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include")
head -1 "$work/raw/times.tsv" > raw/times.tsv
for case in sqlite-1 sqlite-4 rem-pio2-large-1 locals-1000-1; do
    stage=$case
    echo "$stage"
    suite=${case%-*}
    workers=${case##*-}
    cpu=2; reserve=()
    if [[ $workers == 4 ]]; then
        cpu=4
        if command -v cores >/dev/null; then reserve=(cores -n 4 --); fi
    fi
    case $suite in
        sqlite) args=("${sqlite[@]}");;
        rem-pio2-large) args=("${musl[@]}" "$M/src/math/__rem_pio2_large.c");;
        locals-1000) args=("$work/input/locals1000.c");;
    esac
    for ((r=-4; r<100; ++r)); do
        case $(((r + 4) % 4)) in
            0) versions=(base9700 head9700 controlA controlB);;
            1) versions=(controlB controlA head9700 base9700);;
            2) versions=(controlA controlB base9700 head9700);;
            3) versions=(head9700 base9700 controlB controlA);;
        esac
        for p in 0 1 2 3; do
            "$lock" "${reserve[@]}" timeout -k 5 45 taskset -c "$cpu" bash "$work/trial.sh" time "$suite" "$workers" "$r" "$((p % 2))" "${versions[p]}" "$outdir" "${flags[@]}" "${args[@]}" >> scheduling.log 2>&1
        done
    done
done
stage=done
