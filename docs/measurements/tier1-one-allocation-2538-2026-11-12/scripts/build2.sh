#!/bin/bash
# build2.sh NAME COMMIT: the head tree checked out at COMMIT, one Release build without debug information linked at the
# four placements (build.sh shifts) in one hold of the lock, its placed executables copied into bins/NAME-SHIFT.
cd "$(dirname "$0")"
name=${1:?a name}
commit=${2:?a commit}
git -C head checkout -q --detach "$commit" && { git -C head rev-parse HEAD; git -C head status --porcelain | wc -l; } > "COMMIT-$name"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd head && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts/head main_unit_backend.c 0 1088 2176 3264" > "build-$name.log" 2>&1
echo "build exit $?" >> "build-$name.log"
for s in 0 1088 2176 3264; do cp "shifts/head/compiler-$s" "bins/$name-$s"; done
sha256sum bins/$name-* >> "build-$name.log" 2>&1
