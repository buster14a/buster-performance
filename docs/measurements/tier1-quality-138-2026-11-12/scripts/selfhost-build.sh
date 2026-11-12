#!/bin/bash
# selfhost-build.sh NAME...: the compiler's own units (src's print-sources, with its print-compile-flags at
# BUSTER_HOST_ARCH=x86-64: the scalar host, so that no vector code is compared, which #1344 has) built into a stage 2
# compiler by each NAME: tier0 (src/build/compiler, the default tier), tier1 (--tier1), tier1cfg and tier1cfg64 (the
# prototype's --tier1, below), clangO2 and clangO0 (clang with
# the same flags but the build's -O3, unit by unit), the first two as the self-host qualification compiles and links
# them (--lanes 1 a unit; clang -no-pie). Run inside one hold of the lock; the units compile at once on the machine's
# cores. scratch/selfhost/NAME/compiler; results/selfhost/NAME-units.tsv (unit, status, wall, user, system seconds,
# peak RSS KiB), NAME-report.txt (--tier1-report's lines).
set -u
cd "$(dirname "$0")"
root=$PWD
out=$root/results/selfhost
mkdir -p "$out" scratch/selfhost
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
test -x "$root/runrss" || cc -O2 -o "$root/runrss" "$root/tools/runrss.c"
cd src
mapfile -d '' sources < <(BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-sources 2>/dev/null)
mapfile -d '' flags < <(BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags 2>/dev/null)
printf '%s\n' "${flags[@]}" > "$out/flags.txt"
for name in "$@"; do
    work=$root/scratch/selfhost/$name
    rm -rf "$work"; mkdir -p "$work"
    : > "$out/$name-units.tsv"
    case $name in
        tier0) command=("$root/src/build/compiler" --lanes 1 "${flags[@]}") ;;
        tier1) command=("$root/src/build/compiler" --lanes 1 "${flags[@]}" --tier1 --tier1-report --tier1-refusals) ;;
        clangO2|clangO0)
            command=(clang)
            for f in "${flags[@]}"; do [ "$f" = -O3 ] || command+=("$f"); done
            command+=("-${name#clang}") ;;
        clangO2-noinline)
            command=(clang)
            for f in "${flags[@]}"; do [ "$f" = -O3 ] || command+=("$f"); done
            command+=(-O2 -fno-inline) ;;
        tier1cfg|tier1cfg64)
            # The prototype (proto-build.sh's compiler) by --tier1 with BUSTER_EXP_INLINE_CFG=1, which expands the
            # always_inline callees whatever their control flow (tier1cfg), and with BUSTER_EXP_INLINE_STATIC=64 too,
            # every small internal function (tier1cfg64).
            command=("$root/src-proto/build/compiler" --lanes 1 "${flags[@]}" --tier1 --tier1-report --tier1-refusals)
            export BUSTER_EXP_INLINE_CFG=1
            if [ "$name" = tier1cfg64 ]; then export BUSTER_EXP_INLINE_STATIC=64; fi ;;
        B|B+inline)
            # The ladder's bottom rows (ladder-build.sh): clang -O2's front end alone, then mem2reg with SCCP, dead code and
            # CFG cleanup as --tier1's pipeline (B), plus LLVM's inliner (B+inline), then llc -O2.
            command=("$root/selfhost-opt.sh" "$name")
            for f in "${flags[@]}"; do [ "$f" = -O3 ] || command+=("$f"); done ;;
        *) echo "unknown build $name" >&2; exit 1 ;;
    esac
    export work out name root
    printf '%s\0' "${sources[@]}" | xargs -0 -P 8 -I{} bash -c '"$root/runrss" "$out/$name-units.tsv" "$1" "${@:2}" -c -o "$work/$(basename "$1" .c).o" "$1" > "$work/$(basename "$1" .c).log" 2>&1' _ {} "${command[@]}"
    objects=(); for s in "${sources[@]}"; do objects+=("$work/$(basename "$s" .c).o"); done
    clang -no-pie "${objects[@]}" -lm -ldl -lpthread -o "$work/compiler" > "$work/link.log" 2>&1
    echo "link status $?" >> "$out/$name-units.tsv"
    cat "$work"/*.log | grep -E '^tier1' > "$out/$name-report.txt"
    sha256sum "$work/compiler" >> "$out/builds.sha256"
    unset BUSTER_EXP_INLINE_CFG BUSTER_EXP_INLINE_STATIC
done
date -u +%FT%TZ > "$out/build.done"
