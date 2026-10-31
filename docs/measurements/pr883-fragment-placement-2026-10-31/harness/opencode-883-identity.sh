#!/usr/bin/env bash
# Compile the frozen SQLite and Lua inputs with every placement image and print
# the object digest and lowering-node counts. Object identity is the semantic
# check for the placement translation.
set -euo pipefail
root="$HOME/buster-fast-bench/codex-883-takeover-20261031"
out="$root/identity"
mkdir -p "$out"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
pre="$corpus/provenance/gnu17-pinned-predefines.txt"
includes=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
sqlite="$corpus/sqlite/sqlite3.c"
lua="$HOME/buster-fast-bench/codex-926-lua-174afc-20261030/inputs/lua-5.4.8"
for name in base base2 candidate; do
    for shift in 0 16 64 256 1024 2048; do
        image="$root/place-$name/compiler-$shift"
        for case in sqlite lua; do
            if [ "$case" = sqlite ]; then
                input="$sqlite"
                extra=()
            else
                input="$lua/src/lua.c"
                extra=(-I "$lua/src")
            fi
            obj="$out/$name-$shift-$case.o"
            log="$out/$name-$shift-$case.err"
            set +e
            "$image" --time-stages -march=znver5 -std=gnu17 "${includes[@]}" --predefines "$pre" "${extra[@]}" -c "$input" -o "$obj" > "$out/$name-$shift-$case.out" 2> "$log"
            status=$?
            set -e
            nodes=$(grep -m1 '^lowering-nodes' "$log" || true)
            digest=$(sha256sum "$obj" 2>/dev/null | cut -d' ' -f1 || true)
            printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$name" "$shift" "$case" "$status" "${digest:-none}" "${nodes:-none}"
        done
    done
done
