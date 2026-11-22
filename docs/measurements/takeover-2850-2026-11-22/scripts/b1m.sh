#!/bin/bash
# b1.sh COMPILER OUT [FLAGS]: the boundary's exactness (B1). For sqlite3.c, Lua, musl and main.c: the ordinary compile, a
# recording, and the compile with every eligible body supplied and with each half of them; each one's objects and
# diagnostics must be the ordinary compile's. FLAGS is "default" or "wall".
set -uo pipefail
cc=$1; out=$2; flags=${3:-default}; mode=${4:-}
corpus=$HOME/dev/buster-corpus
musl=$corpus/libc/musl
sq=$corpus/sqlite
lua=$HOME/.cache/claude-2850/inputs/lua-5.4.8/src
tree=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$cc")")")")")
mkdir -p "$out"
extra=()
[[ $flags == wall ]] && extra=(-Wall -Wextra)
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
run()
{
    # run DIRECTORY ENVIRONMENT... -- ARGUMENTS...
    local dir=$1; shift
    local environment=()
    while [[ $1 != -- ]]; do environment+=("$1"); shift; done
    shift
    mkdir -p "$dir"
    (cd "$dir" && env "${environment[@]}" "$cc" --lanes 1 -c "${extra[@]}" "$@" > stdout.txt 2> stderr.txt; echo $? > status.txt
     find . -maxdepth 1 -name '*.o' -print0 | sort -z | xargs -0 -r sha256sum > objects.txt; find . -maxdepth 1 -name '*.o' -delete)
}
failures=0
workload()
{
    local name=$1; shift
    local base="$out/$name-$flags"
    mkdir -p "$base/recording"
    run "$base/plain" X=1 -- "$@"
    run "$base/record" "BUSTER_BOUNDARY_RECORD=$base/recording" ${mode:+"$mode"} -- "$@"
    run "$base/all" "BUSTER_BOUNDARY_SUPPLY=$base/recording" ${mode:+"$mode"} -- "$@"
    cat "$base"/recording/*.supplied > "$base/all-supplied.txt" 2> /dev/null
    run "$base/half0" "BUSTER_BOUNDARY_SUPPLY=$base/recording" BUSTER_BOUNDARY_SELECT=2:0 ${mode:+"$mode"} -- "$@"
    run "$base/half1" "BUSTER_BOUNDARY_SUPPLY=$base/recording" BUSTER_BOUNDARY_SELECT=2:1 ${mode:+"$mode"} -- "$@"
    for variant in record all half0 half1; do
        local verdict=same
        cmp -s "$base/plain/objects.txt" "$base/$variant/objects.txt" || verdict=OBJECTS-DIFFER
        cmp -s "$base/plain/stderr.txt" "$base/$variant/stderr.txt" || verdict="$verdict DIAGNOSTICS-DIFFER"
        cmp -s "$base/plain/status.txt" "$base/$variant/status.txt" || verdict="$verdict STATUS-DIFFERS"
        [[ $verdict == same ]] || failures=$((failures + 1))
        printf '%-8s %-8s %-7s objects %4s diagnostics %7s bytes: %s\n' "$name" "$flags" "$variant" "$(wc -l < "$base/$variant/objects.txt")" "$(wc -c < "$base/$variant/stderr.txt")" "$verdict"
    done
    # The recording's census over the workload's units, and what the all-supplied compile took.
    cat "$base"/recording/*.recorded | awk -F'\t' '$1 != "unit-tokens" && $1 != "bodies" && $1 != "taken" && $1 != "dropped" && $1 != "load-ticks" { n[$1] += $2; t[$1] += $3 } $1 == "unit-tokens" { u += $2 } $1 == "bodies" { b += $2 }
        END { printf "  %s: unit tokens %d, bodies %d;", "'"$name"'", u, b; for (k in n) if (n[k]) printf " %s %d (%d tokens)", k, n[k], t[k]; printf "\n" }'
    awk -F'\t' '$1 == "taken" { n += $2; t += $3 } $1 == "dropped" && $2 != "-" { d += 1 } END { printf "  taken %d bodies, %d tokens; units dropped %d\n", n, t, d }' "$base/all-supplied.txt"
}
workload sqlite -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c"
workload lua "$lua"/*.c
workload main -march=native "-I$tree/src" -fwrapv -funsigned-char --predefines "$tree/build/predefines.h" "$tree/src/buster/compiler/main.c" -o main.o
workload musl -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" \
    -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}"
echo "differences: $failures"
