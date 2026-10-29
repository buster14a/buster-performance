#!/usr/bin/env bash
set -euo pipefail
compiler=$(realpath "${1:?usage: validate-sqlite.sh COMPILER CORPUS OUT}")
corpus=$(realpath "${2:?}")
out=$(realpath "${3:?}")
script=$(realpath "$(dirname "$0")/sqlite-smoke.c")
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
export SOURCE_DATE_EPOCH=1792454400 CORES_TITLE='Buster SQLite object validation' CORES_LINK='https://github.com/buster14a/buster'
unset CPATH C_INCLUDE_PATH || true
include=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite")
cores -n 1 -- "$compiler" -c --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 "${include[@]}" -o "$scratch/buster.o" "$corpus/sqlite/sqlite3.c"
cores -n 1 -- clang -c -O0 -std=gnu17 -march=znver5 -undef -Wno-macro-redefined -include "$corpus/provenance/gnu17-pinned-predefines.txt" "${include[@]}" -o "$scratch/clang.o" "$corpus/sqlite/sqlite3.c"
for name in buster clang; do
    clang -O2 -I"$corpus/sqlite" "$script" "$scratch/$name.o" -pthread -lm -ldl -o "$scratch/$name-smoke"
    "$scratch/$name-smoke" > "$out/$name-smoke.txt"
    sha256sum "$scratch/$name.o" | sed 's@  .*@  sqlite-object.o@' > "$out/$name-sqlite-object.sha256"
done
diff -u "$out/clang-smoke.txt" "$out/buster-smoke.txt"
echo 'SQLite output agrees with Clang.'
