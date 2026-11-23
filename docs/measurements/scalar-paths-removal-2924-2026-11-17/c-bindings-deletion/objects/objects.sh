#!/bin/bash
# #2924 C12c-5 (a), in the session's container (Release builds of base and head with CI's toolchain, -march=native on
# the container's AVX-512 host): objects and stderr of -c --lanes 1 of sqlite3.c, Lua's units, musl's units and buster's
# main.c (the complete driver), and sqlite3.c with --lanes 4 --deferred-bodies, by base and head, with -Wall -Wextra,
# --scalar -Wall -Wextra, --tier1 -Wall -Wextra and no warning option. Usage: objects.sh BASE_EXE HEAD_EXE CORPUS SRC OUT
set -uo pipefail
base=$1; head=$2; corpus=$3; src=$4; out=$5
mkdir -p "$out"; : > "$out/status.txt"
sqlite=$corpus/sqlite; musl=$corpus/libc/musl; lua=$corpus/lua-5.4.8/src
export LC_ALL=C
files=(); declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi; done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
B=(-march=znver5 -I"$src/src" -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_COMPLETE_DRIVER=1 "$src/src/buster/compiler/main.c")
W=(-Wall -Wextra)
objects=$out/objects
for mode in wall scalar tier1 default; do
    case $mode in wall) opt=("${W[@]}");; scalar) opt=(--scalar "${W[@]}");; tier1) opt=(--tier1 "${W[@]}");; default) opt=();; esac
    for tree in base head; do
        exe=${!tree}; cur=$objects/$mode/$tree
        mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl" "$cur/buster" "$cur/dsqlite"
        (cd "$cur/sqlite" && "$exe" -c --lanes 1 "${opt[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$cur/sqlite.err"); echo "objects $mode $tree sqlite: $?" >> "$out/status.txt"
        (cd "$cur/lua" && "$exe" -c --lanes 1 "${opt[@]}" "$lua"/*.c > /dev/null 2> "$cur/lua.err"); echo "objects $mode $tree lua: $?" >> "$out/status.txt"
        (cd "$cur/musl" && "$exe" -c --lanes 1 "${opt[@]}" "${M[@]}" "${files[@]}" > /dev/null 2> "$cur/musl.err"); echo "objects $mode $tree musl: $?" >> "$out/status.txt"
        (cd "$cur/buster" && "$exe" -c --lanes 1 "${opt[@]}" "${B[@]}" -o main.o > /dev/null 2> "$cur/buster.err"); echo "objects $mode $tree buster: $?" >> "$out/status.txt"
        (cd "$cur/dsqlite" && "$exe" -c --lanes 4 --deferred-bodies "${opt[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$cur/dsqlite.err"); echo "objects $mode $tree dsqlite: $?" >> "$out/status.txt"
    done
    n=0; d=0
    while read -r f; do n=$((n+1)); cmp -s "$objects/$mode/base/$f" "$objects/$mode/head/$f" || { d=$((d+1)); echo "differs $mode: $f" >> "$out/objects-compare.txt"; }; done < <(cd "$objects/$mode/base" && find . -name '*.o' | sort)
    echo "objects $mode: $n compared, $d differ" >> "$out/status.txt"
    for t in sqlite lua musl buster dsqlite; do
        if cmp -s "$objects/$mode/base/$t.err" "$objects/$mode/head/$t.err"; then v=same; else v=DIFFER; fi
        echo "stderr $mode $t: $(wc -l < "$objects/$mode/base/$t.err") lines base, $(wc -l < "$objects/$mode/head/$t.err") head, $v" >> "$out/status.txt"
    done
done
rm -rf "$objects"
echo done >> "$out/status.txt"
