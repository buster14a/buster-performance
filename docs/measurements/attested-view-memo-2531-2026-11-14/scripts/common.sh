# common.sh: the local corpora (sourced).
corpus=$HOME/.cache/claude-2531/corpus
musl=$corpus/libc/musl
sqlite=$corpus/sqlite
musl_options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
sqlite_options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite")
export LC_ALL=C
musl_units()
{
    local f b
    declare -A seen
    for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
        b=${f##*/}
        if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; printf '%s\n' "$f"; fi
    done
}
glibc_sources=("$HOME"/.cache/claude-2531/glibc/src/*.c)
