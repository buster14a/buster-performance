#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname -- "$0")"
printf 'source-sha=%s\n' a20d741c37f176655aa120cafb085ae69421058a
uname -a
clang --version | head -1
clang -march=znver5 -O2 identity-extract.c -o identity-extract
./identity-extract > tier1-reproducible.c
clang -O0 -march=x86-64 -o oracle tier1-reproducible.c
./oracle > oracle.out
printf 'oracle-output='; cat oracle.out
for remat in 0 1; do
    args=(--tier1 --tier1-report --tier1-refusals --verify -march=x86-64)
    if (( remat == 0 )); then args+=(--tier1-no-rematerialize); fi
    for path in 0 1; do
        pathargs=()
        if (( path == 1 )); then pathargs+=(--scalar); fi
        source/build/compiler "${args[@]}" "${pathargs[@]}" -c -o "identity-$remat-$path.o" tier1-reproducible.c > "compile-$remat-$path.log" 2>&1
        cat "compile-$remat-$path.log"
        if grep -q '^tier1-refused' "compile-$remat-$path.log"; then
            printf 'unexpected-tier1-refusal=%s,%s\n' "$remat" "$path"
            exit 1
        fi
        grep -q $'^tier1\tfunctions=' "compile-$remat-$path.log"
        clang -o "identity-$remat-$path" "identity-$remat-$path.o"
        "./identity-$remat-$path" > "identity-$remat-$path.out"
        cmp oracle.out "identity-$remat-$path.out"
        printf 'execution-match remat=%s path=%s\n' "$remat" "$path"
    done
    if ! cmp "identity-$remat-0.o" "identity-$remat-1.o"; then
        printf 'object-mismatch remat=%s\n' "$remat"
        objdump -dr "identity-$remat-0.o" > "identity-$remat-0.dis"
        objdump -dr "identity-$remat-1.o" > "identity-$remat-1.dis"
        exit 1
    fi
    sha256sum "identity-$remat-0.o" "identity-$remat-1.o"
    printf 'whole-object-match remat=%s\n' "$remat"
done
printf 'identity-validation=PASS\n'
