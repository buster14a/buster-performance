#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
clang -std=c17 -O2 -Wall -Wextra -Werror generate.c -o generate
clang -std=c17 -O2 -Wall -Wextra -Werror instrument.c -o instrument
clang -std=c17 -O2 -Wall -Wextra -Werror verify.c -o verify
for variant in base head; do
    mkdir -p "probe-$variant"
    source=$variant
    if test "$variant" = head; then source=head-final; fi
    ./instrument "$source" "probe-$variant"
    clang -O2 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -I"$source/src" -I"$source/src/buster/compiler" -I"probe-$variant" -I. \
        -Wall -Werror -Wno-unused-function -Wno-unused-variable probe.c -o "probe-$variant/probe" -lm -pthread
done
mkdir -p inputs
for mode in writable readonly relocation literal; do
    for mib in 1 4 16 64; do
        ./generate "$mode" "$((mib * 1024 * 1024))" 1 > "inputs/$mode-$mib.c"
    done
done
for mode in writable readonly relocation; do
    ./generate "$mode" 65536 256 > "inputs/$mode-batch.c"
done
sha256sum inputs/*.c > logs/inputs.sha256
sha256sum base/build/compiler head-final/build/compiler > logs/binaries.sha256
clang --version > logs/toolchain.txt
lscpu > logs/cpu.txt
uname -a > logs/kernel.txt
printf 'base\t92c025e71856d13eb34247477c5294d2cead139e\nhead\t4e21ef63d6d7e8e4ac5766f5043bdb6b06b0d9b7\n' > logs/sources.tsv
printf 'PROBE_BUILD_OK\n'
