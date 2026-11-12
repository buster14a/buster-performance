#!/bin/bash
# selfhost-kinds.sh: the stage 2 compiler's units by src-kinds' --tier1 with their tags (BUSTER_TIER1_KINDS), as
# selfhost-build.sh tier1 compiles them by the plain compiler; each object must be the plain build's bytes. Run inside
# one hold of the lock. scratch/selfhost/kinds/selfhost.kinds, results/selfhost/kinds-objects.txt.
set -u
cd "$(dirname "$0")"
root=$PWD
out=$root/results/selfhost
work=$root/scratch/selfhost/kinds
rm -rf "$work"; mkdir -p "$work"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
cd src
mapfile -d '' sources < <(BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-sources 2>/dev/null)
mapfile -d '' flags < <(BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags 2>/dev/null)
export work root
export BUSTER_TIER1_KINDS=$work/selfhost.kinds
printf '%s\0' "${sources[@]}" | xargs -0 -P 8 -I{} bash -c '"$root/src-kinds/build/compiler" --lanes 1 "${@:2}" --tier1 -c -o "$work/$(basename "$1" .c).o" "$1" > "$work/$(basename "$1" .c).log" 2>&1' _ {} "${flags[@]}"
cd "$root"
same=0; differ=0
for o in "$work"/*.o; do
    if cmp -s "$o" "scratch/selfhost/tier1/$(basename "$o")"; then same=$((same + 1)); else differ=$((differ + 1)); echo "differs: $(basename "$o")"; fi
done > "$out/kinds-objects.txt"
echo "same $same differ $differ lines $(wc -l < "$work/selfhost.kinds")" >> "$out/kinds-objects.txt"
