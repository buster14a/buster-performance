#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=037f264e1f1b6964082bb6a0ad6472bb3702a60a
record=$(cd -- "$(dirname -- "$0")" && pwd -P)
work=$(mktemp -d)
git -C "$work" init -q
git -C "$work" remote add origin https://github.com/buster14a/buster.git
git -C "$work" fetch -q --depth=1 origin "$base"
git -C "$work" checkout -q --detach "$base"
cd "$work"
ev="$work/build/3033-proof"
mkdir -p "$ev"
lscpu | sed -n '/Model name:/p'
cc -O2 -march=x86-64-v4 -maes -mgfni -mvaes -mavx512vbmi -mavx512vbmi2 -mavx512vpopcntdq -mavx512bitalg -mavx512vnni tools/ci/vector-probe.c -o "$ev/probe"
"$ev/probe"
paths=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$paths:$PATH"
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_TOOLCHAIN=path
clang --version | head -1
cmake --version | head -1
ninja --version
git fetch -q --depth=1 origin "$head"
cp -- "$record/kernel.c" "$record/check.c" "$record/check-puff.c" "$ev/"
for name in puff.c puff.h; do
    curl -fsSL --retry 3 "https://raw.githubusercontent.com/madler/zlib/51b7f2abdade71cd9bb0e7a373ef2610ec6f9daf/contrib/puff/$name" -o "$ev/$name"
done
gzip -n9c LICENSE > "$ev/license.gz"
clang -O2 -march=x86-64 -fno-strict-aliasing "$ev/check.c" "$ev/kernel.c" -o "$ev/oracle"
"$ev/oracle"
clang -O2 -march=x86-64 -fno-strict-aliasing -I"$ev" "$ev/check-puff.c" "$ev/puff.c" -o "$ev/puff-oracle"
"$ev/puff-oracle" "$ev/license.gz" > "$ev/puff-oracle.out"
cmp LICENSE "$ev/puff-oracle.out"
status=0
common=(--tier1 --verify --tier1-report -O2 -march=x86-64 -fno-strict-aliasing)
for label in base head; do
    revision=$base
    if [[ "$label" == head ]]; then revision=$head; fi
    git checkout -q --detach "$revision"
    echo "=== $label $(git rev-parse HEAD) ==="
    ./build.sh --config Release
    build/compiler test-ir-optimize || status=1
    if [[ "$label" == head ]]; then
        build/compiler test-ir-optimize --print-text > "$ev/printed.txt" || status=1
        sed -n '/^== memory-narrow$/{n; :a; /^== /q; p; n; ba;}' "$ev/printed.txt" > "$ev/narrow.ir"
        diff -u tests/ir/optimize/memory-narrow-after.ir "$ev/narrow.ir" || status=1
    fi
    build/compiler test-ir-source --passes -march=x86-64 -fno-strict-aliasing "$ev/kernel.c" || status=1
    if [[ "$label" == base ]]; then
        for symbol in put_byte put_word; do
            build/compiler test-ir-source --print "$symbol" -march=x86-64 -fno-strict-aliasing "$ev/kernel.c" || status=1
        done
    fi
    build/compiler "${common[@]}" --tier1-passes=+memory -c "$ev/kernel.c" -o "$ev/$label-kernel.o"
    objdump -d -M intel --no-show-raw-insn "$ev/$label-kernel.o"
    for symbol in put_byte put_word other_byte may_alias; do
        objdump -d -M intel --no-show-raw-insn --disassemble="$symbol" "$ev/$label-kernel.o" > "$ev/$label-$symbol.asm"
    done
    clang -O2 -march=x86-64 -fno-strict-aliasing "$ev/check.c" "$ev/$label-kernel.o" -o "$ev/$label-run"
    "$ev/$label-run" || status=1
    build/compiler "${common[@]}" -c "$ev/kernel.c" -o "$ev/$label-default.o"
    objcopy -O binary -j .text "$ev/$label-default.o" "$ev/$label-default.text"
    build/compiler "${common[@]}" --tier1-passes=+memory -c "$ev/puff.c" -o "$ev/$label-puff.o"
    objcopy -O binary -j .text "$ev/$label-puff.o" "$ev/$label-puff.text"
    wc -c "$ev/$label-puff.text"
    sha256sum "$ev/$label-puff.text"
    clang -O2 -march=x86-64 -fno-strict-aliasing -I"$ev" "$ev/check-puff.c" "$ev/$label-puff.o" -o "$ev/$label-puff"
    "$ev/$label-puff" "$ev/license.gz" > "$ev/$label-puff.out" && cmp "$ev/puff-oracle.out" "$ev/$label-puff.out" || status=1
done
for symbol in put_byte put_word other_byte may_alias; do
    for label in base head; do
        asm="$ev/$label-$symbol.asm"
        reads=$(grep -Ec 'movzx +eax,(BYTE|WORD) PTR \[rdi(\+0x1)?\]' "$asm" || true)
        writes=$(grep -Ec 'mov +DWORD PTR \[rdi\],' "$asm" || true)
        printf '%s %s: narrow reads %s, 32-bit stores %s\n' "$label" "$symbol" "$reads" "$writes"
        expect=1
        if [[ "$label" == head && ( "$symbol" == put_byte || "$symbol" == put_word ) ]]; then expect=0; fi
        [[ "$reads" == "$expect" && "$writes" == 1 ]] || status=1
    done
done
cmp "$ev/base-puff.text" "$ev/head-puff.text" || status=1
cmp "$ev/base-default.text" "$ev/head-default.text" || status=1
sha256sum "$ev/"*-default.text
exit "$status"
