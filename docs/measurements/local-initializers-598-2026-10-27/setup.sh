#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p cases logs
clang -std=c17 -O2 -Wall -Wextra -Werror generate.c -o generate
clang -std=c17 -O2 -Wall -Wextra -Werror compile.c -o compile
clang -std=c17 -O2 -Wall -Wextra -Werror runtime.c -ldl -o runtime
clang -std=c17 -O2 -Wall -Wextra -Werror summarize.c -o summarize
for n in 16 64 120 128 129 136 256 512 2048 8192 32768; do
    ./generate string "$n" > "cases/string-$n.c"
done
for n in 16 32 33 128 512 2048 8192 40000; do
    ./generate list "$n" > "cases/list-$n.c"
done
sha256sum cases/*.c > inputs.sha256
clang --version > toolchain.txt
lscpu > cpu.txt
sha256sum ../base/build/compiler ../head/build/compiler > binaries.sha256
