#!/usr/bin/env bash
# After queue.sh (PID $1): CI's musl symbols comparison on the frozen corpus, base and head, each under the lock on its own.
cd ~/buster-fast-bench/asm-147-claude || exit 1
while kill -0 "$1" 2> /dev/null; do sleep 10; done
export EXCLUSIVE_OWNER=claude-asm-147 EXCLUSIVE_TITLE="Inline assembly lowering (#147, #126)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
L=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
for t in base head; do
    $L taskset -c 0-7 ./timed.sh $t/build/compiler test-checker-corpus --clang /usr/bin/clang --symbols-minimum 348 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe \
        -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" \
        "$musl/src/math" "$musl/src/string" "$musl/src/stdlib" "$musl/src/fenv" "$musl/src/legacy" "$musl/src/process" "$musl/src/signal" "$musl/src/multibyte" > musl-$t.log 2>&1
    echo "$t musl $? $(grep 'symbols compared' musl-$t.log)"
done
echo done
