#!/bin/bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
work=$PWD
source "$work/owner.sh"
lock=$HOME/buster-fast-bench/exclusive.sh
base=56490ed95ac23b1634b0252d8ee1405e54947418
stage=setup
trap 's=$?; printf "%s\t%d\n" "$stage" "$s" > "$work/build-status"' EXIT
mkdir -p src bin logs
git -C src init -q
if ! git -C src cat-file -e "$base^{commit}" 2>/dev/null; then
    git -C src fetch -q --depth=1 https://github.com/buster14a/buster.git "$base"
fi
git -C src checkout -q --detach "$base"
test "$(git -C src rev-parse HEAD)" = "$base"
git -C src apply --check "$work/candidate.patch"
cd "$work/src"
build_command=(./build.sh --config Release --jobs 6)
if command -v cores >/dev/null; then
    build_command=(cores -n 6 -- "${build_command[@]}")
fi
for version in baseline candidate; do
    stage=$version
    echo "building $version"
    if [[ $version == candidate ]]; then
        git apply "$work/candidate.patch"
    fi
    "$lock" timeout -k 5 565 "${build_command[@]}" > "$work/logs/build-$version.log" 2>&1
    cp --reflink=auto build/compiler "$work/bin/$version"
    sha256sum "$work/bin/$version"
    "$lock" timeout -k 5 30 "$work/bin/$version" test-direct > "$work/logs/test-$version.log" 2>&1
    tail -2 "$work/logs/test-$version.log"
done
stage=done
