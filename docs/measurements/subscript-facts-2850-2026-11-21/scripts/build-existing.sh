#!/usr/bin/env bash
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd)
shared="$HOME/buster-fast-bench/2850-codex-step2"
cd "$HOME/buster-fast-bench/2850-subscript-e1d/src"
git apply "$d/next.patch"
git add src
git write-tree > "$d/built.tree"
cmp "$d/expected.tree" "$d/built.tree"
"$shared/lock.sh" bash -c './build.sh --config Release' > "$d/build.log" 2>&1
cp build/compiler "$d/compiler"; sha256sum "$d/compiler" > "$d/compiler.sha256"; date -u > "$d/built"
