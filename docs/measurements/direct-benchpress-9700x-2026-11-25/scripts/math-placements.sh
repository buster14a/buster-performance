#!/bin/bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
work=$PWD
source "$work/owner.sh"
test "$(cat confirm/status)" = $'done\t0'
mkdir -p math
stage=setup
trap 's=$?; printf "%s\t%d\n" "$stage" "$s" > "$work/math/status"' EXIT
lock=$HOME/buster-fast-bench/exclusive.sh
scratch=$(mktemp -d /tmp/buster-direct-math.XXXXXX)
C=$work/corpus
M=$C/libc/musl
args=(--lanes 1 --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -c
      --predefines "$C/provenance/gnu17-pinned-predefines.txt" -D_XOPEN_SOURCE=700
      "-I$M/arch/x86_64" "-I$M/arch/generic" "-I$C/musl-generated/obj/src/internal"
      "-I$M/src/include" "-I$M/src/internal" "-I$C/musl-generated/obj/include" "-I$M/include"
      "$M/src/math/__rem_pio2_large.c")
printf 'placement\t' > math/times.tsv
head -1 raw/times.tsv >> math/times.tsv
for g in 0 1 2 3; do
    stage=placement-$g
    echo "$stage"
    dir=$scratch/$g
    mkdir -p "$dir"/{bin,raw,out}
    cp "$work/bin/time-one" "$dir/bin/time-one"
    case $g in
        0) copies=(base9700 head9700 controlB);;
        1) copies=(head9700 controlB base9700);;
        2) copies=(controlB head9700 base9700);;
        3) copies=(base9700 controlB head9700);;
    esac
    for name in "${copies[@]}"; do
        target=baseline
        if [[ $name == head9700 ]]; then target=candidate; fi
        "$lock" timeout -k 2 15 cp --reflink=never "$work/bin/$target" "$dir/bin/$name"
    done
    ln "$dir/bin/base9700" "$dir/bin/controlA"
    (cd "$dir/bin" && sha256sum base9700 head9700 controlA controlB) > "$work/math/placement-$g.sha256"
    cd "$dir"
    for ((r=-4; r<52; ++r)); do
        case $(((r+g+4) % 4)) in
            0) versions=(base9700 head9700 controlA controlB);;
            1) versions=(controlB controlA head9700 base9700);;
            2) versions=(controlA controlB base9700 head9700);;
            3) versions=(head9700 base9700 controlB controlA);;
        esac
        for p in 0 1 2 3; do
            "$lock" timeout -k 5 45 taskset -c 2 bash "$work/trial.sh" time rem-pio2-large 1 "$r" "$((p%2))" "${versions[p]}" "$dir/out" "${args[@]}" >> "$work/math/scheduling.log" 2>&1
        done
    done
    awk -v g="$g" '{print g "\t" $0}' raw/times.tsv >> "$work/math/times.tsv"
    rm -f -- bin/{base9700,head9700,controlA,controlB}
    cd "$work"
done
stage=done
