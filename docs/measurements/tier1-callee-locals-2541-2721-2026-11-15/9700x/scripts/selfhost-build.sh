#!/bin/bash
# selfhost-build.sh NAME...: the compiler's own units (the tree's print-sources, with its print-compile-flags at
# BUSTER_HOST_ARCH=x86-64: the scalar host, as #138's record measured) built into a stage 2 compiler by each NAME, which
# is TREE-KIND: TREE main or head, KIND tier1 (the tree's Release compiler, --tier1), noinline (--tier1
# --tier1-no-inline) or clangO2 (clang with the same flags but the build's -O3); --lanes 1 a unit, linked as the
# self-host qualification links (clang -no-pie). The record's selfhost-build.sh, by tree. Run inside one hold of the lock;
# the units compile at once on 8 cores. scratch/selfhost/NAME/compiler; results/selfhost/NAME-units.tsv (unit, status,
# wall, user, system seconds, peak RSS KiB), NAME-report.txt (--tier1-report's lines).
set -u
cd "$(dirname "$0")"
root=$PWD
out=$root/results/selfhost
mkdir -p "$out" scratch/selfhost
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
test -x "$root/runrss" || cc -O2 -o "$root/runrss" "$root/tools/runrss.c"
for name in "$@"; do
    tree=${name%%-*}
    kind=${name#*-}
    mapfile -d '' sources < <(cd "$root/$tree" && BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-sources 2>/dev/null)
    mapfile -d '' flags < <(cd "$root/$tree" && BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags 2>/dev/null)
    printf '%s\n' "${flags[@]}" > "$out/$tree-flags.txt"
    work=$root/scratch/selfhost/$name
    rm -rf "$work"; mkdir -p "$work"
    : > "$out/$name-units.tsv"
    case $kind in
        tier1) command=("$root/$tree/build/compiler" --lanes 1 "${flags[@]}" --tier1 --tier1-report --tier1-refusals) ;;
        noinline) command=("$root/$tree/build/compiler" --lanes 1 "${flags[@]}" --tier1 --tier1-no-inline --tier1-report --tier1-refusals) ;;
        clangO2)
            command=(clang)
            for f in "${flags[@]}"; do [ "$f" = -O3 ] || command+=("$f"); done
            command+=(-O2) ;;
        *) echo "unknown build $name" >&2; exit 1 ;;
    esac
    export work out name root tree
    printf '%s\0' "${sources[@]}" | xargs -0 -P 8 -I{} bash -c 'cd "$root/$tree" && "$root/runrss" "$out/$name-units.tsv" "$1" "${@:2}" -c -o "$work/$(basename "$1" .c).o" "$1" > "$work/$(basename "$1" .c).log" 2>&1' _ {} "${command[@]}"
    objects=(); for s in "${sources[@]}"; do objects+=("$work/$(basename "$s" .c).o"); done
    clang -no-pie "${objects[@]}" -lm -ldl -lpthread -o "$work/compiler" > "$work/link.log" 2>&1
    echo "link status $?" >> "$out/$name-units.tsv"
    cat "$work"/*.log | grep -E '^tier1' > "$out/$name-report.txt"
    sha256sum "$work/compiler" >> "$out/builds.sha256"
done
date -u +%FT%TZ > "$out/build.done"
