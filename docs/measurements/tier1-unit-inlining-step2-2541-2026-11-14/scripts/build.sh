#!/bin/bash
# build.sh DIRECTORY: one Release build of DIRECTORY (the default host, znver5 here) in one hold of the lock.
cd "$(dirname "$0")"
directory=${1:?a tree}
mkdir -p results
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd $directory && time ./build.sh --config Release" > "results/build-$directory.log" 2>&1
status=$?; echo "build exit $status" >> "results/build-$directory.log"
sha256sum "$directory/build/compiler" >> "results/build-$directory.log" 2>&1
exit $status
