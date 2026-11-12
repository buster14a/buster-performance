#!/bin/bash
# build.sh DIRECTORY: one Release build of DIRECTORY (the default host, native: znver5 here) in one hold of the lock.
cd "$(dirname "$0")"
directory=${1:?a source directory}
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd $directory && time ./build.sh" > "build-$directory.log" 2>&1
echo "build exit $?" >> "build-$directory.log"
sha256sum "$directory/build/compiler" >> "build-$directory.log" 2>&1
