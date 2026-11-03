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
printf 'lock_receipt\twrapper=/home/david/buster-fast-bench/exclusive.sh\towner=%s\theld=%s\tutc=%s\n' "$EXCLUSIVE_OWNER" "${BUSTER_9700X_HELD-}" "$(date -u --iso-8601=ns)" >> "$out/lock-receipts.log"
cp build/cmake/znver5-g0/.ninja_log "$out/ninja.edit.before"
printf '\n' >> src/buster/compiler/tier1_model_measure.c
cp src/buster/compiler/tier1_model_measure.c "$out/tier1_model_measure.edited.c"
status=0
{ time taskset -c 0-7 ./build.sh --config Release --jobs 8 </dev/null; } > "$out/edit.log" 2>&1 || status=$?
printf 'exit_status\t%d\n' "$status" >> "$out/edit.log"
test "$status" -eq 0
cp build/cmake/znver5-g0/.ninja_log "$out/ninja.edit.after"
sha256sum build/cmake/znver5-g0/Release/compiler > "$out/compiler.after-edit.sha256"
cp "$out/tier1_model_measure.original.c" src/buster/compiler/tier1_model_measure.c
cmp "$out/tier1_model_measure.original.c" src/buster/compiler/tier1_model_measure.c
