#!/bin/bash
# build-shifts.sh LABEL BASE [PATCH] SHIFT...: trees/work reset to BASE with PATCH (or "-" for none), built by
# ./build.sh shifts --config Release with each SHIFT bytes of padding before the checker unit's code (main_unit_checker.c,
# which holds the node machine), in one hold of the lock; each executable kept as results/LABEL-sSHIFT/compiler.
set -u
cd "$(dirname "$0")"
label=$1
base=$2
patch=$3
shift 3
out=$PWD/results/$label-shifts
mkdir -p "$out"
git -C src fetch -q origin "$base" 2>/dev/null || git -C src fetch -q origin main
git -C trees/work checkout -q -- . && git -C trees/work clean -qfd src || exit 1
git -C trees/work checkout -q --detach "$base" || exit 1
if [ "$patch" != "-" ]; then git -C trees/work apply "$PWD/$patch" || { echo "patch failed"; exit 1; }; fi
{ git -C trees/work rev-parse HEAD; [ "$patch" != "-" ] && sha256sum "$patch"; } > "$out/revision.txt"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd trees/work && ./build.sh shifts --config Release $out/bin main_unit_checker.c $*" > "$out/build.log" 2>&1
status=$?
echo "status $status" >> "$out/build.log"
[ $status = 0 ] || { echo "build failed"; exit 1; }
for s in "$@"; do
    mkdir -p "results/$label-s$s"
    cp "$out/bin/compiler-$s" "results/$label-s$s/compiler"
    sha256sum "results/$label-s$s/compiler" > "results/$label-s$s/compiler.sha256"
    cp "$out/revision.txt" "results/$label-s$s/"
done
echo built
