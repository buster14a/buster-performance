#!/usr/bin/env bash
set -euo pipefail
repo=$(realpath "${1:?pass a Buster checkout}")
out=$(realpath -m "${2:?pass a new output directory}")
record=$(dirname "$(realpath "$0")")
base=3741c264fb349e86359acfd1c732ee1c2eaa4052
head=adcac4b9173b020927894b12443c659bfa458cc5
test "$(uname -sm)" = 'Linux x86_64'
model=$(awk -F ': ' '/^model name/{print $2;exit}' /proc/cpuinfo)
[[ -n $model && $model != *9700X* ]]
printf 'Host %s\n' "$model"
clang -march=native -fsyntax-only -x c "$repo/src/buster/compiler/host_isa.h"
mkdir -p "$out"
test -z "$(ls -A "$out")"
# Both objects are available from the public PR and its base.
if ! git -C "$repo" cat-file -e "$head^{commit}"; then git -C "$repo" fetch origin refs/pull/3098/head; fi
git -C "$repo" worktree add --detach "$out/base" "$base"
git -C "$repo" worktree add --detach "$out/head" "$head"
run_build() {
    if [[ -n ${BUSTER_ROW_CORE_RUNNER:-} ]]; then
        "$BUSTER_ROW_CORE_RUNNER" ./build.sh --config Debug --jobs 1
    elif command -v cores >/dev/null; then
        CORES_TITLE='Preserving unwind rows' CORES_LINK=https://github.com/buster14a/buster/issues/3081 cores -n 1 -- ./build.sh --config Debug --jobs 1
    else
        ./build.sh --config Debug --jobs 1
    fi
}
export BUSTER_HOST_ARCH=native BUSTER_TOOLCHAIN=ci
for version in base head; do
    (cd "$out/$version" && run_build && BUSTER_COMPILER="$PWD/build/compiler" ./build/compiler test-emitted-code) > "$out/$version.log" 2>&1
    tail -1 "$out/$version.log"
done
bash "$record/compare_objects.sh" "$out/base/build/compiler" "$out/head/build/compiler" "$out/driver"
sed -n '/no_caller_saved_registers/p' "$record/frames.c" > "$out/keep.c"
for version in base head; do
    "$out/$version/build/compiler" --verify -c -march=x86-64-v4 "$out/keep.c" -o "$out/$version-keep.o"
done
cmp "$out/base-keep.o" "$out/head-keep.o"
# The local probe modifies only this disposable head worktree, after recording the pristine head outputs.
git -C "$out/head" apply "$record/probe.patch"
(cd "$out/head" && run_build) > "$out/probe-build.log" 2>&1
mkdir "$out/replay"
cd "$out/replay"
BUSTER_COMPILER="$out/head/build/compiler" "$out/head/build/compiler" test-emitted-code > probe.log
BUSTER_CAPTURE_PRESERVING=1 "$out/head/build/compiler" --verify -c -march=x86-64-v4 "$out/keep.c" -o "$out/probe-keep.o" 2> "$out/driver-work.txt"
cmp "$out/head-keep.o" "$out/probe-keep.o"
cat "$out/driver-work.txt"
set -- base-*.rows
test "$#" -eq 112
set -- head-*.rows
test "$#" -eq 112
for a in base-*.rows; do
    case_id=${a#base-}; case_id=${case_id%.rows}
    for version in base head; do
        prefix=$version-$case_id
        printf '.section .eh_frame,"a",@progbits\n.incbin "%s.eh"\n' "$prefix" | as --64 -o "$prefix.o" -
        readelf --debug-dump=frames-interp "$prefix.o" > "$prefix.frames" 2> "$prefix.err"
        test ! -s "$prefix.err"
        grep -q 'FDE cie=' "$prefix.frames"
    done
    for ext in rows eh frames; do cmp "base-$case_id.$ext" "head-$case_id.$ext"; done
done
awk 'BEGIN {OFS="\t";print "case","revision","interrupt","gp","vector","mask","fixed","total","moved","gp_visits","vector_visits","new_rows","cfi_bytes"} /^PROBE / {$1="";print substr($0,2)}' probe.log > "$out/work.tsv"
test "$(wc -l < "$out/work.tsv")" -eq 225
{
    printf 'Cases %s\n' "$#"
    printf 'Complete 16-byte rows %s\n' "$(($(cat base-*.rows | wc -c)/16))"
    printf 'CIE/FDE bytes %s\n' "$(cat base-*.eh | wc -c)"
    printf 'Decoded readelf state rows including CIEs %s\n' "$(cat base-*.frames | grep -cE '^0[0-9a-f]{15} ')"
    for ext in rows eh frames; do printf '%s  %s\n' "$(cat base-*."$ext" | sha256sum | cut -d' ' -f1)" "$ext"; done
    tail -1 probe.log
} | tee "$out/summary.txt"
if [[ -f $record/work.tsv ]]; then cmp "$record/work.tsv" "$out/work.tsv"; fi
if [[ -f $record/driver-work.txt ]]; then cmp "$record/driver-work.txt" "$out/driver-work.txt"; fi
