#!/bin/bash
# #2924 C10: the encoder's last partial group by masked loads (tailexp.patch: encode_group loads a partial group's
# records by masked loads of their dwords and takes its forms from them, with no zeroed copy) against main bc66290c5, on
# the 9700X, Release, every run under the lock on CPU 2. benchmark-x86-encoder's compiler mix, vector mix, 32-bit and
# 16-bit modes at 1, 2, 4 and 16 instructions a call and whole: the scalar loop and the mode's production loop alone
# (--only), by base and by the experiment in turn, three rounds.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the x86 encoder's tail" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs compilers
for side in base exp; do
    if [ ! -d src-$side ]; then git clone -q --shared $D/../c10gate/src src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$side checkout -q --detach bc66290c5 && git -C src-$side reset -q --hard
done
git -C src-exp apply "$D/tailexp.patch" || { echo "patch failed" >> logs/status.txt; exit 1; }
for side in base exp; do
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
for mode in "" "--vector" "--mode32" "--mode16"; do
    case "$mode" in
        --mode32) production=x86_encode_16_mode32 ;;
        --mode16) production=x86_encode_16_mode16 ;;
        *) production=x86_encode_16 ;;
    esac
    for section in 1 2 4 16 0; do
        name="encoder${mode:+-${mode#--}}-section$section"
        args=()
        [ -n "$mode" ] && args+=("$mode")
        [ "$section" != 0 ] && args+=(--section "$section")
        for round in 1 2 3; do
            for side in base exp; do
                for only in scalar $production; do
                    $L timeout -k 5 900 taskset -c 2 ./compilers/$side benchmark-x86-encoder "${args[@]}" --only $only > "logs/$name-$side-$only-$round.log" 2>&1
                    echo "$name-$side-$only-$round: $?" >> logs/status.txt
                done
            done
        done
    done
done
echo done >> logs/status.txt
