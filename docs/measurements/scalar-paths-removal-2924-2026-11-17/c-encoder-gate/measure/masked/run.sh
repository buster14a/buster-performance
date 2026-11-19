#!/bin/bash
# #2924 C10's measure gate, second run: x86_measure, x86_measure_scalar and an experiment measure whose last partial group
# is loaded by masked loads from the instructions (measure_masked), on main bc66290c5 plus c10-measure-masked.patch,
# Release, every run under the lock on CPU 2. benchmark-x86-encoder's compiler mix and vector mix at 1, 2, 3, 4, 8 and
# 16 instructions a call and the whole stream: each measure entry alone (--only), three rounds, in turn.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the x86 encoder's measure gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
if [ ! -d src ]; then git clone -q --shared $D/../c10gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
git -C src checkout -q --detach bc66290c5 && git -C src reset -q --hard
git -C src apply "$D/c10-measure-masked.patch" || { echo "patch failed" >> logs/status.txt; exit 1; }
git -C src rev-parse HEAD > logs/commit.txt
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compiler
for mode in "" "--vector"; do
    for section in 1 2 3 4 8 16 0; do
        name="measure${mode:+-${mode#--}}-section$section"
        args=()
        [ -n "$mode" ] && args+=("$mode")
        [ "$section" != 0 ] && args+=(--section "$section")
        for round in 1 2 3; do
            for only in measure_scalar measure_vector measure_masked; do
                $L timeout -k 5 900 taskset -c 2 ./compiler benchmark-x86-encoder "${args[@]}" --only $only > "logs/$name-$only-$round.log" 2>&1
                echo "$name-$only-$round: $?" >> logs/status.txt
            done
        done
    done
done
echo done >> logs/status.txt
