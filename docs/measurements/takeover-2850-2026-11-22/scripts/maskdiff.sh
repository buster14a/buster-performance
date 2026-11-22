#!/bin/bash
# maskdiff.sh OLD_COMPILER NEW_COMPILER OUT: the mask change's differential. Both compilers carry the experiment that masks
# the bodies whose ordinal modulo N is K (BUSTER_EXPERIMENT_MASK_BODIES=N:K), so that kept bodies stand next to masked
# ones; OLD has main's conditions, NEW the branch's. For sqlite3.i, Lua, musl and main.c, by default and with -Wall
# -Wextra, with no mask and with three partial masks, the objects and the diagnostics of the two must be one set.
set -uo pipefail
old=$1; new=$2; out=$3
corpus=$HOME/dev/buster-corpus
musl=$corpus/libc/musl
lua=$HOME/.cache/claude-2850/inputs/lua-5.4.8/src
tree=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$new")")")")")
rm -rf "$out"; mkdir -p "$out"
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
run()
{
    # run NAME COMPILER MASK FLAGS... -- ARGUMENTS...: objects into a fresh directory, their hashes and the diagnostics kept.
    local name=$1 cc=$2 mask=$3; shift 3
    local dir="$out/$name"
    mkdir -p "$dir"
    (cd "$dir" && if [[ $mask == none ]]; then "$cc" --lanes 1 -c "$@" > stdout.txt 2> stderr.txt; else BUSTER_EXPERIMENT_MASK_BODIES=$mask "$cc" --lanes 1 -c "$@" > stdout.txt 2> stderr.txt; fi; echo $? > status.txt
     find . -name '*.o' -print0 | sort -z | xargs -0 -r sha256sum > objects.txt; rm -f ./*.o)
}
failures=0
compare()
{
    local workload=$1 mask=$2 flags=$3; shift 3
    local key="$workload-${mask//:/_}-$flags"
    local extra=()
    [[ $flags == wall ]] && extra=(-Wall -Wextra)
    run "$key-old" "$old" "$mask" "${extra[@]}" "$@"
    run "$key-new" "$new" "$mask" "${extra[@]}" "$@"
    local verdict=same
    cmp -s "$out/$key-old/objects.txt" "$out/$key-new/objects.txt" || verdict=OBJECTS-DIFFER
    cmp -s "$out/$key-old/stderr.txt" "$out/$key-new/stderr.txt" || verdict="$verdict DIAGNOSTICS-DIFFER"
    cmp -s "$out/$key-old/status.txt" "$out/$key-new/status.txt" || verdict="$verdict STATUS-DIFFERS"
    [[ $verdict == same ]] || failures=$((failures + 1))
    printf '%-28s status %s objects %4s diagnostics %7s bytes masked [%s]: %s\n' "$key" "$(cat "$out/$key-new/status.txt")" "$(wc -l < "$out/$key-new/objects.txt")" \
        "$(wc -c < "$out/$key-new/stderr.txt")" "$(grep -c '^experiment-mask' "$out/$key-new/stderr.txt")" "$verdict"
}
for mask in none 2:0 2:1 3:1; do
    for flags in default wall; do
        compare sqlite "$mask" "$flags" "$HOME/.cache/claude-2850/bound/sqlite3.i"
        compare lua "$mask" "$flags" "$lua"/*.c
        compare musl "$mask" "$flags" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" \
            -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}"
        compare main "$mask" "$flags" -march=native "-I$tree/src" -fwrapv -funsigned-char --predefines "$tree/build/predefines.h" "$tree/src/buster/compiler/main.c" -o main.o
    done
done
echo "differences: $failures"
