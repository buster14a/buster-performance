#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD
out=$PWD/results/active-direct-batches
mkdir -p "$out"
if ! test -d trees/activesourcebatches;then git -C src worktree add -q --detach "$PWD/trees/activesourcebatches" 0e1d5b825;fi
cd trees/activesourcebatches
git apply --check "$root/active-direct-batches.patch" && git apply "$root/active-direct-batches.patch"
cd "$root";source corpora.sh;eval "args=($sqlite_arguments)"
./lock.sh taskset -c 2 bash -c '
set -e
out=$1;root=$2;shift 2
export PATH="$(bash trees/factsmain0e1d/tools/ci/session-toolchain.sh stage):$PATH"
src=$root/trees/activesourcebatches/src
clang -O3 -gline-tables-only -fno-omit-frame-pointer -std=gnu17 -fwrapv -funsigned-char -march=native -I"$src" -I"$src/buster/compiler" active-source-fresh.c -o "$out/pilot"
PP_PRINT="$out/pilot.i" "$out/pilot" "$@" >"$out/pilot.tsv" 2>"$out/pilot.err"
sha256sum "$out/pilot.i" "$root/results/active-source-profile/ordinary.i" >"$out/hashes"
cmp "$out/pilot.i" "$root/results/active-source-profile/ordinary.i"
' _ "$out" "$root" "${args[@]}" >"$out/build.log" 2>&1
