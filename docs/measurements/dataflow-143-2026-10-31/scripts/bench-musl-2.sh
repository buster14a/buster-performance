#!/bin/bash
set -uo pipefail
cd /tmp/opencode/takeover-942
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
taskset -c 2 ./build/compiler test-ir-source --dataflow-benchmark --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os \
  -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" \
  "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c > bench-musl-2.out 2> bench-musl-2.err
status=$?
printf 'exit=%d\n' "$status" > bench-musl-2.status
exit "$status"
