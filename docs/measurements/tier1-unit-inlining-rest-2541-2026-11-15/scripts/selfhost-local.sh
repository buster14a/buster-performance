#!/bin/bash
# build.sh TREE COMPILER OUT [EXTRA...]: the compiler's units at the scalar host by COMPILER --tier1 (lanes 1), linked by clang.
set -u
tree=$1; compiler=$2; out=$3; shift 3
mkdir -p "$out"
cd "$tree"
mapfile -d '' sources < <(BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-sources 2>/dev/null)
mapfile -d '' flags < <(BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags 2>/dev/null)
export compiler out
printf '%s\0' "${sources[@]}" | xargs -0 -P 3 -I{} bash -c '"$compiler" --lanes 1 "${@:2}" --tier1 --tier1-report -c -o "$out/$(basename "$1" .c).o" "$1" > "$out/$(basename "$1" .c).log" 2>&1 || echo "FAILED $1"' _ {} "${flags[@]}" "$@"
objects=(); for s in "${sources[@]}"; do objects+=("$out/$(basename "$s" .c).o"); done
clang -no-pie "${objects[@]}" -lm -ldl -lpthread -o "$out/compiler" > "$out/link.log" 2>&1; echo "link $?"
