#!/usr/bin/env bash
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd)
shared="$HOME/buster-fast-bench/2850-codex-step2"
cd "$d"
base=232da75f980c7ff9f01ffa3d849d655970bbed78
git clone -q --shared --no-checkout "$shared/src" src
if ! git -C src cat-file -e "$base"; then git -C src fetch -q https://github.com/buster14a/buster "$base"; fi
git -C src checkout --quiet --detach "$base"
git -C src apply "$d/projection.patch"
git -C src add src
git -C src write-tree > built.tree
test "$(cat built.tree)" = "$(cat expected.tree)"
cd src
"$shared/lock.sh" bash -c './build.sh --config Release' > "$d/build.log" 2>&1
cp build/compiler "$d/compiler"
sha256sum "$d/compiler" > "$d/compiler.sha256"
date -u > "$d/built"
