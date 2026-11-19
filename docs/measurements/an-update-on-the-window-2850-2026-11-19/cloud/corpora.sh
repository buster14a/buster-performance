# corpora.sh, sourced: the three corpora's files and options in this container (copied from benchpress's
# /var/lib/buster-9700x/corpora/preprocessor-391e729af658 and 868-claude/inputs/lua-5.4.8).
corpus=/home/user/corpus
sqlite=$corpus/sqlite
lua=$corpus/lua/lua-5.4.8/src
musl=$corpus/libc/musl
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
sqlite_arguments="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
lua_arguments=$(printf '%q ' "$lua"/*.c)
musl_arguments="$(printf '%q ' -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")$(printf '%q ' "${files[@]}")"
main_arguments="-march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c"
