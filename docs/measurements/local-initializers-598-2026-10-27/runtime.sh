#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
for input in cases/*.c; do
    stem=${input##*/}
    stem=${stem%.c}
    for variant in base head; do
        object="logs/$variant-$stem.o"
        if test -f "$object"; then
            size -A "$object" > "logs/$variant-$stem.sections"
            objdump -dr "$object" > "logs/$variant-$stem.disasm"
            # The object-mode unwind references its function by name. Bind that definition locally in the test DSO.
            clang -shared -Wl,-Bsymbolic-functions "$object" -o "logs/$variant-$stem.so"
        fi
    done
    if test -f "logs/base-$stem.so" && test -f "logs/head-$stem.so"; then
        ./runtime "./logs/base-$stem.so" "./logs/head-$stem.so" "${stem%-*}" "${stem##*-}"
    elif test -f "logs/head-$stem.so"; then
        clang -O0 -fPIC -c "$input" -o "logs/clang-$stem.o"
        clang -shared -Wl,-Bsymbolic-functions "logs/clang-$stem.o" -o "logs/clang-$stem.so"
        size -A "logs/clang-$stem.o" > "logs/clang-$stem.sections"
        ./runtime "./logs/clang-$stem.so" "./logs/head-$stem.so" "${stem%-*}" "${stem##*-}" |
            sed -e 's/^runtime,base,/runtime,clang,/' -e 's/^verified,base,/verified,clang,/'
    fi
done
