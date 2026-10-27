#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# These total array sizes also cover exactly 512, 2048, 8192 and 32768 literal letters plus their terminator.
for n in 513 2049 8193 32769; do
    ./generate string "$n" > "cases/string-$n.c"
done
sha256sum cases/*.c > inputs.sha256
rm -f logs/base-*.o logs/head-*.o logs/base-*.so logs/head-*.so
for input in cases/*.c; do
    stem=${input##*/}
    stem=${stem%.c}
    kind=${stem%-*}
    n=${stem##*-}
    ./compile ../base/build/compiler ../head/build/compiler "$input" "$kind" "$n" logs
done
bash runtime.sh
