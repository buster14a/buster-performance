#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p inputs logs tmp objects
(cd ../base && sha256sum --check ../evidence/base-sources.sha256)
(cd ../head && sha256sum --check ../evidence/head-sources.sha256)
clang -std=c17 -O2 -Wall -Wextra -Werror generate.c -o generate
for kind in strings repeated wide records pointers characters integers; do
    for n in 20000 40000 80000 160000; do
        ./generate "$kind" "$n" > "inputs/$kind-$n.c"
    done
done
sha256sum generate.c verify.c inputs/*.c > inputs.sha256
clang --version
tcc -v
uname -a
lscpu
sha256sum ../base/build/compiler ../head/build/compiler
