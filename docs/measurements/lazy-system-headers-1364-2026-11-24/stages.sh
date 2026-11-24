#!/bin/bash
# Run on benchpress with a pinned znver5 Release compiler. One shared lock per stage sample.
set -euo pipefail
cd "$(dirname "$0")"
tree=${1:?build directory}
tag=${2:?result directory}
compiler=$PWD/$tree/build/compiler
mkdir -p "$tag"
out=$(cd "$tag" && pwd)
lock=$HOME/buster-fast-bench/exclusive.sh
audit=$HOME/buster-fast-bench/perf-audit-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=codex-1364 EXCLUSIVE_TITLE="Issue 1364: $tag" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1364
inputs=(sqlite glibc mixed intrinsic)
# Only include paths, as required by the public headers. No feature or warning policy changes from pkg-config.
read -ra inc <<< "$(pkg-config --cflags-only-I python3 gio-2.0 libxml-2.0)"
printf '#include <immintrin.h>\nint main(void){return 0;}\n' > "$out/intrinsic.c"
{
    uname -srmo
    lscpu | grep -E '^Model name|^CPU max MHz|^L3 cache'
    getconf GNU_LIBC_VERSION
    pkg-config --modversion python3 gio-2.0 libxml-2.0 openssl libcurl libdw libarchive ncurses
    sha256sum "$compiler" "$sqlite/sqlite3.c" "$audit/inputs/glibc380.c" "$audit/inputs/lib_all.c" "$out/intrinsic.c"
    printf 'pkg-config include flags: %s\n' "${inc[*]}"
} > "$out/environment.txt"
for input in "${inputs[@]}"; do
    case $input in
        sqlite) args=(-w -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$out/sqlite.o");;
        glibc) args=(-w -fsyntax-only "$audit/inputs/glibc380.c");;
        mixed) args=(-w -fsyntax-only "${inc[@]}" "$audit/inputs/lib_all.c");;
        intrinsic) args=(-w -fsyntax-only "$out/intrinsic.c");;
    esac
    for mode in eager lazy; do
        flags=()
        if [[ $mode = lazy ]]; then flags=(-flazy-system-headers); fi
        "$lock" timeout -k 5 60 taskset -c 2 "$compiler" --time-stages "${flags[@]}" "${args[@]}" > "$out/$input-$mode.stages" 2>&1
        if [[ $input = sqlite ]]; then sha256sum "$out/sqlite.o" | cut -d' ' -f1 > "$out/sqlite-$mode.sha256"; fi
    done
    if [[ $input = sqlite ]]; then cmp "$out/sqlite-eager.sha256" "$out/sqlite-lazy.sha256"; fi
    echo "$input done"
done
