#!/usr/bin/env bash
set -euo pipefail
compiler=$(realpath "${1:?usage: zen5-profiles.sh COMPILER CORPUS OUT}")
corpus=$(realpath "${2:?}")
out=$(realpath "${3:?}")
mkdir -p "$out/profiles-extra"
out=$(realpath "$out/profiles-extra")
export EXCLUSIVE_OWNER=codex-microarch-20261029 EXCLUSIVE_TITLE='Buster 9700X detailed profiles' EXCLUSIVE_LINK='https://github.com/buster14a/buster-performance/pull/120'
export SOURCE_DATE_EPOCH=1792454400 LC_ALL=C
unset CPATH C_INCLUDE_PATH || true
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
common=("$compiler" -c --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features
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
    if "$HOME/buster-fast-bench/exclusive.sh" timeout 60 taskset -c 2 \
        perf record -q "${args[@]}" -o "$out/$name.data" -- bash -c "$repeat" repeat "${common[@]}" \
        > "$out/$name.stdout" 2> "$scratch/$name.stderr"; then
        echo 0 > "$out/$name.status"
        perf report --stdio --no-children --percent-limit 0.25 -i "$out/$name.data" > "$out/$name.report.txt" 2>&1 || true
        perf script -d -i "$out/$name.data" -F event > /dev/null 2> "$out/$name.integrity.txt" || true
        if [[ $name == ibs-op ]]; then
            perf mem report --stdio --dsos compiler --sort mem --percent-limit 0 -i "$out/$name.data" > "$out/$name.compiler-memory.txt" 2>&1 || true
        fi
        zstd -q -f --rm "$out/$name.data"
    else
        echo "$?" > "$out/$name.status"
    fi
    sed -e '/^exclusive.sh: /d' -e '/^  title: /d' -e '/^  link: /d' "$scratch/$name.stderr" > "$out/$name.stderr"
    printf '%s complete\n' "$name"
done
