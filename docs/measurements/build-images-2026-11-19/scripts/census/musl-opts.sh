# Sourced: musl's options as the one-core record's scripts/musl.sh gives them, over the frozen corpus.
corpus=${CORPUS:?set CORPUS to the frozen corpus root (buster tools/ci/fetch-corpus.sh)}
musl="$corpus/libc/musl"
opts=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
