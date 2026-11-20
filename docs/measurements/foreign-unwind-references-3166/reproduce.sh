#!/usr/bin/env bash
# Run on an identified, isolated non-9700X Linux/x86-64 vector host.
# Arguments are the Buster checkout and a new or empty output directory.
set -euo pipefail
if [ "$#" != 2 ]; then
    echo "usage: bash reproduce.sh BUSTER_CHECKOUT EMPTY_OUTPUT_DIRECTORY" >&2
    exit 2
fi
root=$(git -C "$1" rev-parse --show-toplevel)
record=$(cd "$(dirname "$0")" && pwd -P)
mkdir -p "$2"
out=$(cd "$2" && pwd -P)
if [ -n "$(ls -A -- "$out")" ]; then
    echo "The output directory must be empty" >&2
    exit 2
fi
cpu=$(LC_ALL=C lscpu | awk '/^Model name:/ {sub(/^[^:]*:[[:space:]]*/, ""); print; exit}')
printf 'Host CPU %s\n' "$cpu"
if [ -z "$cpu" ] || [[ "$cpu" == *9700X* ]]; then
    echo "This reproduction needs an identified non-9700X host" >&2
    exit 2
fi
base=198a76539df21f444e4be4e968a14f06fb43531f
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none
git -C "$root" worktree add --detach "$out/probe-tree" "$base"
cd "$out/probe-tree"
mapfile -d '' -t flags < <(./build.sh print-host-flags)
cc -O2 "${flags[@]}" tools/ci/vector-probe.c -o "$out/vector-probe"
"$out/vector-probe"
git apply --check "$record/paired-probe.patch"
git apply "$record/paired-probe.patch"
./build.sh --config Release
bash "$record/run.sh" "$PWD/build/compiler" "$PWD/build/compiler" "$out/paired" | tee "$out/paired.log"

# Verify two independently built, uninstrumented linkers on the same fixtures.
for side in before after; do
    tree="$out/$side-tree"
    git -C "$root" worktree add --detach "$tree" "$base"
    if [ "$side" = after ]; then git -C "$tree" apply "$record/candidate.patch"; fi
    (cd "$tree" && ./build.sh --config Release && ./build/compiler test-foreign --cross-check) > "$out/$side.suite.log" 2>&1
done
bash "$record/run.sh" "$out/before-tree/build/compiler" "$out/after-tree/build/compiler" "$out/independent" | tee "$out/independent.log"
