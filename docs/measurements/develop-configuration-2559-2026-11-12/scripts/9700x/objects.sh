#!/bin/bash
# Whether Release's and Develop's executables write the same outputs (buster#2559's correctness gate), to be run inside
# the 9700X lock (lock.sh): objects.sh. The frozen sqlite3.c's object, at both tiers, and -c, -E and -fsyntax-only of
# each of the compiler's own main.c units with the build's flags. Results in results/objects.txt.
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
release=$d/src/build/cmake/native/Release/compiler
develop=$d/src/build/cmake/native/Develop/compiler
out=$d/scratch/objects
rm -rf "$out"; mkdir -p "$out"
cd "$d/src" || exit 2
head -1 /var/lib/buster-9700x/owner > "$d/results/objects.holder.txt"
mapfile -d '' -t all < <(./build.sh print-compile-flags)
# The build's flags less -g, -O3, -Wall and -Werror, as tools/ci/selfhost.c takes them.
flags=()
for flag in "${all[@]}"; do
    case "$flag" in
        -g|-O3|-Wall|-Werror) ;;
        *) flags+=("$flag") ;;
    esac
done
results=$d/results/objects.txt
: > "$results"
check() {
    local name=$1; shift
    "$release" "$@" -o "$out/$name.release" > "$out/$name.release.log" 2>&1; local r=$?
    "$develop" "$@" -o "$out/$name.develop" > "$out/$name.develop.log" 2>&1; local v=$?
    local verdict=different
    cmp -s "$out/$name.release" "$out/$name.develop" && [ "$r" = "$v" ] && verdict=same
    printf '%s\t%s\trelease=%s develop=%s\t%s\n' "$name" "$verdict" "$r" "$v" "$(sha256sum < "$out/$name.release" | cut -c1-16)" >> "$results"
}
sq=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
check sqlite-c -c "${sq[@]}"
check sqlite-c-tier1 -c --tier1 "${sq[@]}"
check sqlite-E -E "${sq[@]}"
for source in $(./build.sh print-sources | tr '\0' '\n' | grep '/main'); do
    unit=$(basename "$source" .c)
    check "$unit-c" -c "${flags[@]}" "$source"
    check "$unit-E" -E "${flags[@]}" "$source"
done
echo "done: $(grep -c same "$results") same, $(grep -c different "$results") different" >> "$results"
