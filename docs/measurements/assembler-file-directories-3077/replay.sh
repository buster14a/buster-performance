#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail
if [[ $# != 2 ]]; then
    echo 'usage: bash replay.sh BUSTER_REPOSITORY NEW_OUTPUT_DIRECTORY' >&2
    exit 2
fi
repo=$(realpath "$1")
packet=$(cd -- "$(dirname -- "$0")" && pwd)
base=3741c264fb349e86359acfd1c732ee1c2eaa4052
head=4cd28ea7c69cba3dec5a4f7ec82926f40f76113b
# Use an already verified, permitted local host. This replay launches local processes only.
[[ $(uname -sm) == 'Linux x86_64' ]]
case "$(LC_ALL=C lscpu | sed -n 's/^Model name: *//p')" in
    ""|*9700X*) echo 'Replay requires a verified non-9700X AVX-512 host.' >&2; exit 2;;
esac
clang -march=native -fsyntax-only -x c "$repo/src/buster/compiler/host_isa.h"
git -C "$repo" cat-file -e "$base^{commit}"
if ! git -C "$repo" cat-file -e "$head^{commit}" 2>/dev/null; then
    [[ -f "$packet/assembler-file-directory.patch" ]] || { echo 'Fetch the PR branch or place its patch beside replay.sh.' >&2; exit 2; }
fi
mkdir "$2"
out=$(realpath "$2")
export BUSTER_HOST_ARCH=native BUSTER_SANITIZER=none BUSTER_ORACLE_CACHE=off
export CORES_TITLE="Numbered .file directory replay" CORES_LINK=https://github.com/buster14a/buster/issues/3077
function local_run {
    local n=$1
    shift
    if command -v cores >/dev/null; then cores -n "$n" -- "$@"; else "$@"; fi
}
for side in base head; do
    tree="$out/source-$side"
    git clone -q --shared --no-checkout "$repo" "$tree"
    if [[ $side == head ]] && git -C "$tree" cat-file -e "$head^{commit}" 2>/dev/null; then
        git -C "$tree" checkout -q --detach "$head"
    else
        git -C "$tree" checkout -q --detach "$base"
        if [[ $side == head ]]; then git -C "$tree" apply "$packet/assembler-file-directory.patch"; fi
    fi
    (
        cd "$tree"
        local_run 2 ./build.sh --config Debug --jobs 2
        cp build/compiler "$out/$side"
        BUSTER_COMPILER="$out/$side" local_run 1 "$out/$side" test-assembler
        git apply "$packet/count-$side.patch"
        local_run 2 ./build.sh --config Debug --jobs 2
        cp build/compiler "$out/$side-counted"
    )
done
bash "$packet/compare.sh" "$out/base" "$out/head" "$out/base-counted" "$out/head-counted" "$repo" "$out/results"
