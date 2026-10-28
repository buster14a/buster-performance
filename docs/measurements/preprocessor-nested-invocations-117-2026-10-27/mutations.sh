#!/usr/bin/env bash
set -u
for kind in paint pending-in expanding; do
(
    tree="work/pp643-mutant-$kind"
    clang -O1 -march=native -I"$tree/src" -fwrapv -funsigned-char -fno-strict-aliasing -Wno-unused-function -ffunction-sections -fdata-sections work/pp643-focused.c work/preprocessor-lexer-home.c -Wl,--gc-sections -o "work/pp643-$kind" > "work/pp643-$kind-build.log" 2>&1
    built=$?
    if test "$built" = 0; then
        env -u CPATH -u C_INCLUDE_PATH "work/pp643-$kind" > "work/pp643-$kind.log" 2>&1
        echo "$kind build $built test $?"
    else
        echo "$kind build $built"
    fi
) &
done
wait
