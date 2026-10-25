#!/bin/bash
# PR #432's review: three trees on the six small units, in rounds whose order rotates, each run locked: final (e6042e6c,
# the PR head's code: every lane copies the reader before the partition), lazy (9a5f8500: no more lanes than bodies, each
# copying the reader at its first part) and cap (9a5f8500 with the copy made before the partition again).
D=~/buster-fast-bench/deferred-113-claude
cd "$D" || exit 1
while ! grep -qx done "$D/log5.txt"; do sleep 30; done
export EXCLUSIVE_OWNER=claude-432-review
export EXCLUSIVE_TITLE="PR #432 review: deferred lanes, cap against lazy copies"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/432"
L="$D/log6.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
(cd "$D/cap" && LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh) >> "$L" 2>&1
echo "build cap exit=$? $(date -Is)" >> "$L"
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
small=("$D/inputs/00001.c" "$D/inputs/00169.c" "$D/inputs/00213.c" "$D/inputs/00182.c" "$D/inputs/00204.c" "$D/inputs/00200.c")
orders=("final lazy cap" "lazy cap final" "cap final lazy")
for round in 1 2 3 4 5 6; do
    order="${orders[$(((round - 1) % 3))]}"
    for t in $order; do
        echo "== round $round $t small" >> "$L"
        ~/buster-fast-bench/exclusive.sh "$D/$t/build/compiler" benchmark-checker-deferred --passes 21 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "${small[@]}" >> "$L" 2>&1
        echo "exit=$? $(date -Is)" >> "$L"
        sleep 20
    done
done
echo done >> "$L"
