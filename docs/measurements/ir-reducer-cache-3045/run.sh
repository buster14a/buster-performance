#!/usr/bin/env bash
# Run at the root of a disposable buster checkout. Pass the measured head SHA for the paired run.
set -euo pipefail
record=$(cd -- "$(dirname -- "$0")" && pwd)
base=b847801169f2b73aed6496c8fa23e9a5499c94e7
head=${1:-}
out=$(mktemp -d)
test "$(git rev-parse HEAD)" = "$base"
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_LINKER=auto
staged=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$staged:$PATH"
clang --version
cmake --version | head -n1
ninja --version
roles=(base)
if [[ -n "$head" ]]; then
    git fetch --depth=1 origin "$head"
    roles+=(head)
fi
for role in "${roles[@]}"; do
    revision=$base
    if [[ "$role" == head ]]; then revision=$head; git switch --detach "$head"; fi
    echo "revision $role $(git rev-parse HEAD)"
    ./build.sh print-compile-flags --config Release > "$out/$role.flags"
    sha256sum "$out/$role.flags"
    ./build.sh --config Release > "$out/build.log" 2>&1 || { tail -60 "$out/build.log"; exit 1; }
    ./build/compiler test-ir-reduce --seed 733 --count 64
    bash "$record/inputs.sh" "$out/$role-input"
    if [[ "$role" == head ]]; then
        cmp "$out/base.flags" "$out/head.flags"
        for input in real stress; do cmp "$out/base-input/$input.ir" "$out/head-input/$input.ir"; done
    fi
    for mode in clean counts; do
        if [[ "$mode" == counts ]]; then
            git apply "$record/count-$role.patch"
            ./build.sh --config Release > "$out/build.log" 2>&1 || { tail -60 "$out/build.log"; exit 1; }
        fi
        echo "run $role $mode"
        bash "$record/cases.sh" "$out/base-input" "$out/$role-$mode" "$revision"
        for name in real-natural real stress exhausted rejected; do
            left="$out/base-clean/$name"
            right="$out/$role-$mode/$name"
            cmp "$left.rc" "$right.rc"
            cmp "$left.out" "$right.out"
            diff -u <(awk '!/^cache-work |^observe /' "$left.err") <(awk '!/^cache-work |^observe /' "$right.err")
            if [[ -e "$left/result.json" ]]; then
                cmp "$left/original.ir" "$right/original.ir"
                cmp "$left/reduced.ir" "$right/reduced.ir"
                diff -u <(jq -S 'del(.source_revision,.binary_bytes,.binary_fnv1a64)' "$left/result.json") <(jq -S 'del(.source_revision,.binary_bytes,.binary_fnv1a64)' "$right/result.json")
            fi
            if [[ "$mode" == counts ]]; then
                sha256sum "$right.order"
                cmp "$out/base-counts/$name.order" "$right.order"
            fi
        done
    done
    git restore src/buster/compiler/ir_reduce.c
done
echo 'PASS: reducer runs, output bytes, manifests, rejection and lookup traces'
