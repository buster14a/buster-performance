set -euo pipefail
W=/home/david/buster-fast-bench/devin-review-1191-738f297b-20261103
root=$W/source
out=$W/receipts
export PATH=/home/david/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin:/usr/bin:/bin:/usr/local/bin:/home/david/.local/bin
export LD_LIBRARY_PATH=/home/david/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/lib
export LC_ALL=C
unset BUSTER_HOST_RUNTIME BUSTER_BUILD_DEFINES BUSTER_FUZZ_ENTRY BUSTER_PGO_TRAIN BUSTER_COMPILER
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_LINKER=auto BUSTER_SANITIZER=none BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_FUZZ_AVAILABLE=0 BUSTER_BAKE=1 BUSTER_PGO=0
TIMEFORMAT=$'MEASURE\twall_s=%3R\tuser_s=%3U\tsystem_s=%3S'
cd "$root"
test ! -e build
{ date -u --iso-8601=ns; uname -a; lscpu; clang --version; /usr/bin/cmake --version; /usr/bin/ninja --version; command -v clang cmake ninja wild mold ld.lld ld.bfd || true; sha256sum build.sh cmake/BusterSettings.cmake cmake/BusterPostLink.cmake /usr/bin/cmake /usr/bin/ninja; printf '%s\n' 'source=738f297ba6aa55ef18aed2f5b0237bbbf108762a legacy-builder=96b6cbcd122ffdc45700cf01d6e8adb40a81243c' 'ISA=znver5 debug=0 sanitizer=none fuzz=0 PGO=0 bake=1 linker=auto CPUs=0-7 jobs=8'; } > "$out/metadata.txt" 2>&1
status=0
{ time taskset -c 0-7 ./build.sh --config Release --jobs 8 </dev/null; } > "$out/clean.log" 2>&1 || status=$?
printf 'exit_status\t%d\n' "$status" >> "$out/clean.log"
test "$status" -eq 0
cp build/cmake/znver5-g0/Release/compiler "$out/compiler.cmake"
cp build/cmake/znver5-g0/.ninja_log "$out/ninja.clean"
sha256sum "$out/compiler.cmake" > "$out/compiler.cmake.sha256"
./build.sh print-compile-flags > "$out/flags.argv"
cp src/buster/compiler/tier1_model_measure.c "$out/tier1_model_measure.original.c"
