#!/bin/bash
# build.sh: one Release build of src (the default host, native here) in one hold of the lock, with the 9700X job's
# toolchain (build.sh stages it). build-src.log has the holder, the time and the executable's hash.
cd "$(dirname "$0")"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd src && time ./build.sh --config Release" > build-src.log 2>&1
echo "build exit $?" >> build-src.log
sha256sum src/build/compiler >> build-src.log 2>&1
