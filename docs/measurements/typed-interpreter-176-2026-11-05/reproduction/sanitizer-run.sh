#!/bin/bash
set -u
cd /home/david/buster-fast-bench/176-codex-01a1ac7e/tree || exit 1
export EXCLUSIVE_OWNER=codex-176 EXCLUSIVE_TITLE='Issue 176 sanitizer qualification' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1331
while [ ! -f ../acceptance-build.status ]; do sleep 2; done
[ "$(cat ../acceptance-build.status)" = 0 ] || exit 1
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=address BUSTER_SANITIZER_OPTIMIZATION=1 ./build.sh > ../sanitizer-build.log 2>&1
built=$?
echo "build: $built" > ../sanitizer.status
[ "$built" = 0 ] || exit 1
export BUSTER_COMPILER="$PWD/build/cmake/native-address-O1/Release/compiler"
export ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" parallel --jobs 4 < ../sanitizer.tests > ../sanitizer-tests.log 2>&1
echo "suites: $?" >> ../sanitizer.status
~/buster-fast-bench/exclusive.sh /usr/bin/clang -O2 tools/dco/dco.c -o ../dco > ../dco-build.log 2>&1
echo "DCO build: $?" >> ../sanitizer.status
cd ../audit || exit 1
~/buster-fast-bench/exclusive.sh ../dco audit --base 76ad7ebe --head qualify176 > ../dco-audit.log 2>&1
echo "DCO audit: $?" >> ../sanitizer.status
