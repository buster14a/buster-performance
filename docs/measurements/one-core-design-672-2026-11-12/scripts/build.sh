#!/bin/bash
# build.sh: one Release build of src (the default host, znver5 here) in one hold of the lock.
cd "$(dirname "$0")"
echo $$ > build.pid
./lock.sh bash -c "cd src && ./build.sh" > build.log 2>&1
echo "build exit $?" >> build.log
sha256sum src/build/compiler >> build.log 2>&1
