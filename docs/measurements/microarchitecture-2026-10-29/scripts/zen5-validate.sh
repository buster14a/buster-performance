#!/usr/bin/env bash
set -euo pipefail
compiler=$(realpath "${1:?usage: zen5-validate.sh COMPILER CORPUS OUT SMOKE_SOURCE}")
corpus=$(realpath "${2:?}")
out=$(realpath "${3:?}")
smoke=$(realpath "${4:?}")
export EXCLUSIVE_OWNER=codex-microarch-20261029 EXCLUSIVE_TITLE='Buster 9700X SQLite validation' EXCLUSIVE_LINK='https://github.com/buster14a/buster-performance/pull/120'
export SOURCE_DATE_EPOCH=1792454400 LC_ALL=C
unset CPATH C_INCLUDE_PATH || true
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
lock="$HOME/buster-fast-bench/exclusive.sh"
include=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite")
"$lock" timeout 60 taskset -c 2 "$compiler" -c --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 "${include[@]}" -o "$scratch/buster.o" "$corpus/sqlite/sqlite3.c"
"$lock" timeout 60 taskset -c 2 clang -c -O0 -std=gnu17 -march=znver5 -undef -Wno-macro-redefined -Wno-builtin-macro-redefined -include "$corpus/provenance/gnu17-pinned-predefines.txt" "${include[@]}" -o "$scratch/clang.o" "$corpus/sqlite/sqlite3.c"
for name in buster clang; do
    "$lock" timeout 60 taskset -c 2 clang -O2 -I"$corpus/sqlite" "$smoke" "$scratch/$name.o" -pthread -lm -ldl -o "$scratch/$name-smoke"
    "$lock" timeout 60 taskset -c 2 "$scratch/$name-smoke" > "$out/$name-smoke.txt"
    sha256sum "$scratch/$name.o" | sed 's@  .*@  sqlite-object.o@' > "$out/$name-sqlite-object.sha256"
done
diff -u "$out/clang-smoke.txt" "$out/buster-smoke.txt"
echo 'SQLite output agrees with Clang.'
