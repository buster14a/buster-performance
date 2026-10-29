#!/usr/bin/env bash
set -euo pipefail
compiler=$(realpath "${1:?usage: scalar-control.sh COMPILER CORPUS OUT}")
corpus=$(realpath "${2:?}")
out=$(realpath "${3:?}")
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
export SOURCE_DATE_EPOCH=1792454400 CORES_TITLE='Buster vector and scalar controls' CORES_LINK='https://github.com/buster14a/buster'
unset CPATH C_INCLUDE_PATH || true
mkdir -p "$out/scalar-control"
common=(--time-stages -c --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features
        -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include"
        -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include"
        -I"$corpus/sqlite" "$corpus/sqlite/sqlite3.c")
for round in 0 1 2 3 4 5 6; do
    if (( round % 2 == 0 )); then order=(vector scalar); else order=(scalar vector); fi
    for path in "${order[@]}"; do
        extra=()
        if [[ $path == scalar ]]; then extra=(--scalar); fi
        cores -n 1 -- bash -c 'exec taskset -c "${CORES_CPUS%%,*}" "$@"' pin \
            perf stat --no-big-num -x ';' -o "$out/scalar-control/$path-$round.csv" \
            -e 'task-clock,cycles,instructions,branches,branch-misses,minor-faults,context-switches' -- \
            "$compiler" "${extra[@]}" "${common[@]}" -o "$scratch/$path-$round.o" \
            > "$out/scalar-control/$path-$round.out" 2> "$out/scalar-control/$path-$round.stderr"
        sha256sum "$scratch/$path-$round.o" | sed 's@  .*@  sqlite.o@' > "$out/scalar-control/$path-$round.sha256"
    done
done
