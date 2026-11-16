# musl-common.sh: sourced by the musl scripts. The frozen corpus's musl, the one-core record's selection (the first source
# of each base name, 1,336 units) and options (one-core-design-672-2026-11-12's scripts/musl.sh).
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
export LC_ALL=C
