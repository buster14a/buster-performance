#!/usr/bin/env bash
# One build of the generated-program runtime matrix; called under the shared lock.
set -euo pipefail
for size in 16 32 64 128 255 256 257 512 1024 4096 8192 16384 65536 262144; do
    for version in base head; do
        if [ -f "objects/$version-$size-copy.o" ] && [ -f "objects/$version-$size-kept.o" ] && [ -f "objects/$version-$size-same.o" ]; then
            clang -O2 -std=c17 -Wall -Wextra -Werror -DN="$size" runtime.c "objects/$version-$size-copy.o" "objects/$version-$size-kept.o" "objects/$version-$size-same.o" -o "runs/$version-$size"
            size -A "objects/$version-$size-copy.o" > "logs/size-$version-$size.txt"
        fi
    done
    if ((size <= 256)); then
        ../head/build/compiler --lanes 1 --verify -c "inputs/$size-forced.c" -o "objects/forced-$size.o"
        clang -O2 -std=c17 -Wall -Wextra -Werror -DN="$size" runtime.c "objects/forced-$size.o" -o "runs/forced-$size"
    fi
done
