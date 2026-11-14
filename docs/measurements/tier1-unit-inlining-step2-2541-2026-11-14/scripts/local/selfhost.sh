#!/bin/bash
# selfhost.sh: the compiler's units (BUSTER_HOST_ARCH=x86-64's sources and flags) by stage1 --tier1, --lanes 1 each, two at
# once, linked into stage2 by clang -no-pie.
cd /home/user/buster
mapfile -d '' sources < <(BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-sources 2>/dev/null)
mapfile -d '' flags < <(BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags 2>/dev/null)
out=$HOME/.cache/claude-2541/selfhost
export out
printf '%s\0' "${sources[@]}" | xargs -0 -P 2 -I{} bash -c 'nice "$out/stage1" --lanes 1 "${@:2}" --tier1 -c -o "$out/$(basename "$1" .c).o" "$1" > "$out/$(basename "$1" .c).log" 2>&1' _ {} "${flags[@]}"
objects=(); for s in "${sources[@]}"; do objects+=("$out/$(basename "$s" .c).o"); done
clang -no-pie "${objects[@]}" -lm -ldl -lpthread -o "$out/stage2" > "$out/link.log" 2>&1
echo "link status $?" > "$out/done"
