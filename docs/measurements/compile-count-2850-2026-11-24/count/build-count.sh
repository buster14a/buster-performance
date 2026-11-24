#!/bin/bash
# build-count.sh CLANG OPT OUT: the instrumented compiler from print-sources and print-compile-flags, at optimization OPT.
set -euo pipefail
clang=$1; opt=$2; out=$3
cd /home/user/buster
mapfile -d '' sources < <(./build.sh print-sources)
mapfile -d '' flags < <(./build.sh print-compile-flags --config Release)
objdir=$out.objects; rm -rf "$objdir"; mkdir -p "$objdir"
kept=()
for f in "${flags[@]}"; do case "$f" in -g|-O3) ;; *) kept+=("$f") ;; esac; done
start=$(date +%s)
pids=()
objects=()
for s in "${sources[@]}"; do
    o="$objdir/$(basename "$s").o"
    objects+=("$o")
    "$clang" -c "$s" -o "$o" "${kept[@]}" "$opt" -fprofile-instr-generate &
    pids+=($!)
    while [ "$(jobs -rp | wc -l)" -ge 4 ]; do wait -n; done
done
wait
"$clang" -fprofile-instr-generate "${objects[@]}" -o "$out" -static -Wl,--push-state,--as-needed -lm -Wl,--pop-state -ldl
echo "built $out in $(( $(date +%s) - start )) s"
