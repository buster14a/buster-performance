set -euo pipefail
mode=$1
root="$PWD"
out="$root/upper-vectors-3662"
base="$root/base3661/build/compiler"
head="$root/pr3662/build/compiler"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
case "$mode" in
    default|tier1)
        printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check > "$out/$mode-objects.txt"
        flags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
        options=()
        if [[ "$mode" == tier1 ]]; then options=(--tier1 -O2 -march=znver5); fi
        cd "$root/pr3662"
        taskset -c 2 "$head" measure-compile --runs 31 --reference "$base" -- -c "${options[@]}" "${flags[@]}" > "$out/compile-$mode.txt" 2>&1
        for side in base head; do
            compiler=$base
            if [[ "$side" == head ]]; then compiler=$head; fi
            taskset -c 2 "$compiler" -c "${options[@]}" "${flags[@]}" -o "$out/$mode-$side.o"
        done
        sha256sum "$out/$mode-base.o" "$out/$mode-head.o" >> "$out/$mode-objects.txt"
        size "$out/$mode-base.o" "$out/$mode-head.o" >> "$out/$mode-objects.txt"
        ;;
    lexer)
        mkdir -p "$out/lexer-work"
        cd "$root/pr3662"
        taskset -c 2 "$head" measure-tier1-rows --runs 21 --clang clang --base "$base" --march znver5 --lexer src/buster/compiler/c_lexer.c --directory "$out/lexer-work" > "$out/lexer.txt" 2>&1
        ;;
    programs-*)
        bash ./programs-3662.sh "${mode#programs-}"
        ;;
    *)
        exit 2
        ;;
esac
