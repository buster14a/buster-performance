#!/usr/bin/env bash
# One bounded aggregate-copy benchmark run, including its generator/native-harness preparation.
# Call through exclusive.sh; the compiler release builds are separate prior lock holds.
set -euo pipefail
(cd ../head && sha256sum -c ../evidence/source-head.sha256) > logs/source-head-verify.log
strings ../head/build/compiler | grep -F 'bytes[16384];};extern volatile int observed' > logs/binary-source-witness.txt
clang -std=c17 -O2 -Wall -Wextra -Werror generate.c -o generate
clang -std=c17 -O2 -Wall -Wextra -Werror compare.c -o compare
mkdir -p inputs objects runs tmp logs
{
    date -Is
    lscpu
    clang --version
    uname -a
    sha256sum ../base/build/compiler ../head/build/compiler generate compare *.c *.sh
} > logs/identity.txt
for size in 16 32 64 128 255 256 257 512 1024 4096 8192 16384 65536 262144; do
    for mode in copy kept same all forced; do ./generate "$size" "$mode" > "inputs/$size-$mode.c"; done
done
sha256sum inputs/*.c > logs/inputs.sha256
exec taskset -c 2 ./compare 0 full
