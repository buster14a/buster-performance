#!/usr/bin/env bash
set -euo pipefail
out=$1
mkdir -p "$out"
export BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=none BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_DEBUG_INFO=0 BUSTER_LINKER=auto
paths=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$paths:$PATH" BUSTER_TOOLCHAIN=path
resource=$(clang -print-resource-dir)
test -f "$resource/include/immintrin.h"
export BUSTER_CLANG_RESOURCE_DIR="$resource"
llvm_lib=$(llvm-config --libdir)
export LD_LIBRARY_PATH="$llvm_lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
git rev-parse HEAD
clang --version
printf 'Clang resource directory: %s\n' "$resource"
./build.sh --config Release --jobs "$(nproc)"
./build.sh print-compile-flags --config Release > "$out/base.flags"
sha256sum build/compiler "$out/base.flags"
bash tools/clang-server/build.sh "$out/clang-server"
status=0
for part in 7 6; do
    build/compiler test-checker-driver --executable "$PWD/build/compiler" --in-process --clang-server "$out/clang-server" --part "$part/8" 2>&1 | tee "$out/driver-$part.log" || status=1
done
grep -E '^CC compatibility: [1-9][0-9]* checks, 0 failures$' "$out/driver-6.log" || status=1
echo "Baseline dependency partitions status=$status"
exit "$status"
