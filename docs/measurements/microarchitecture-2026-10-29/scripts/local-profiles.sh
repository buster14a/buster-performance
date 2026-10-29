#!/usr/bin/env bash
set -euo pipefail
compiler=${1:?usage: local-profiles.sh COMPILER CORPUS OUT}
corpus=${2:?}
out=${3:?}
mkdir -p "$out/profiles-extra"
export CORES_TITLE='Buster detailed local profiling'
export CORES_LINK='https://github.com/buster14a/buster'
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH || true
compiler=$(realpath "$compiler")
corpus=$(realpath "$corpus")
out=$(realpath "$out/profiles-extra")
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
command=("$compiler" -c --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features
    -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include"
    -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include"
    -I"$corpus/sqlite" -o "$scratch/sqlite.o" "$corpus/sqlite/sqlite3.c")
repeat='for ((i=0;i<30;i++)); do "$@" >/dev/null 2>/dev/null || exit $?; done'
for name in cycles-all ibs-op ibs-fetch branches; do
    case "$name" in
        cycles-all) args=(-e cycles -F 997 --call-graph dwarf,8192) ;;
        ibs-op) args=(-e 'ibs_op/cnt_ctl=1,period=100003/' -d -W) ;;
        ibs-fetch) args=(-e 'ibs_fetch/period=1000003/') ;;
        branches) args=(-e cycles:u -F 997 -j any,u) ;;
    esac
    if cores -n 1 -- bash -c 'exec taskset -c "${CORES_CPUS%%,*}" "$@"' pin \
        perf record -q "${args[@]}" -o "$out/$name.data" -- bash -c "$repeat" repeat "${command[@]}" \
        > "$out/$name.stdout" 2> "$out/$name.stderr"; then
        echo 0 > "$out/$name.status"
        perf report --stdio --no-children --percent-limit 0.25 -i "$out/$name.data" > "$out/$name.report.txt" 2>&1 || true
        perf script -d -i "$out/$name.data" -F event > /dev/null 2> "$out/$name.integrity.txt" || true
        if [[ $name == ibs-op ]]; then
            perf mem report --stdio -i "$out/$name.data" > "$out/$name.memory.txt" 2>&1 || true
        fi
        zstd -q -f --rm "$out/$name.data"
    else
        echo "$?" > "$out/$name.status"
    fi
    printf '%s complete\n' "$name"
done
