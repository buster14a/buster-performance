#!/usr/bin/env bash
# Usage: ./reproduce.sh /path/to/buster /new/local/output-directory
set -euo pipefail
repo=$(realpath "${1:?provide a Buster checkout}")
out=$(realpath -m "${2:?provide a new results directory}")
here=$(cd "$(dirname "$0")" && pwd)
sha=198a76539df21f444e4be4e968a14f06fb43531f
model=$(LC_ALL=C lscpu | sed -n 's/^Model name:[[:space:]]*//p')
if [[ -z "$model" || "$model" == *9700X* || $(hostname -s) == benchpress ]]; then
    echo "This reproduction requires an identified, non-9700X AVX-512 host." >&2
    exit 1
fi
mkdir "$out"
git -C "$repo" worktree add --detach "$out/checkout" "$sha"
cd "$out/checkout"
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0
export BODY_INPUTS="$out/inputs"
tool_path=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$tool_path:$PATH"
clang -march=native -fsyntax-only -x c src/buster/compiler/host_isa.h
printf 'Host %s, CPU %s\n' "$(hostname -s)" "$model"
clang --version | head -1
jobs=${JOBS:-1}
run() {
    if [[ -n ${BODY_RUNNER:-} ]]; then
        CORES="$jobs" "$BODY_RUNNER" "$@"
    elif command -v cores >/dev/null; then
        CORES_TITLE='Typed source body lookups' CORES_LINK='https://github.com/buster14a/buster/issues/3154' cores -n "$jobs" -- "$@"
    else
        CORES="$jobs" "$@"
    fi
}
build() {
    run bash -c './build.sh --config Develop --jobs "$CORES"'
}
git apply --include=tests/interpreter/units-library.c "$here/3154.patch"
build
"$here/run-cases.sh" build/compiler "$out/base"
run "$here/correctness.sh" build/compiler > "$out/base-correctness.txt" 2>&1
CLANG=clang "$here/native.sh" "$out/native"
git apply "$here/base-probe.patch"
build
"$here/run-cases.sh" build/compiler "$out/base-probe" probe
git apply -R "$here/base-probe.patch"
git apply --include=src/buster/compiler/interpreter_source.c "$here/3154.patch"
build
"$here/run-cases.sh" build/compiler "$out/head"
run "$here/correctness.sh" build/compiler > "$out/head-correctness.txt" 2>&1
git apply "$here/head-probe.patch"
build
"$here/run-cases.sh" build/compiler "$out/head-probe" probe
git apply -R "$here/head-probe.patch"
"$here/verify.sh" "$out"
