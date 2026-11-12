# common.sh: sourced by the measurement scripts: the corpus, the options and the units.
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl="$corpus/libc/musl"
sqlite_options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite")
musl_options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
# The options of a preprocessed musl unit: the language's and the target's alone.
musl_i_options=(-std=c99 -nostdinc -ffreestanding)
export LC_ALL=C
# musl's units: the first source of each base name (two units of one name would write one object), as the first
# record's musl.sh takes them.
musl_units()
{
    local f b
    declare -A seen
    for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
        b=${f##*/}
        if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; printf '%s\n' "$f"; fi
    done
}
