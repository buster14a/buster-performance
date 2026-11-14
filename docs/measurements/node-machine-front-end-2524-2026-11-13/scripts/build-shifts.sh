#!/bin/bash
# build-shifts.sh LABEL SHIFT...: trees/LABEL (build-patch.sh's worktree) built by ./build.sh shifts with that many bytes of
# padding before the checker unit's code (main_unit_checker.c, which holds the node machine), in one hold of the lock; each
# executable kept as results/LABEL-sSHIFT/compiler. The build directories are left for a removal by their literal paths.
set -u
cd "$(dirname "$0")"
label=$1
shift
out=$PWD/results/$label-shifts
mkdir -p "$out"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd trees/$label && ./build.sh shifts $out/bin main_unit_checker.c $*" > "$out/build.log" 2>&1
echo "status $?" >> "$out/build.log"
for s in "$@"; do
    mkdir -p "results/$label-s$s"
    cp "$out/bin/compiler-$s" "results/$label-s$s/compiler"
    sha256sum "results/$label-s$s/compiler" > "results/$label-s$s/compiler.sha256"
    cp "results/$label/revision.txt" "results/$label-s$s/"
done
