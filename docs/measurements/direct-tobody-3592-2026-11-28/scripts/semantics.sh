#!/bin/bash
# semantics.sh COMPILER DIR: DIR/ctype.c (glibc's tolower and toupper under -O2, every arm, a call's argument counted)
# and DIR/constant-p.c (__builtin_constant_p of operands with side effects), each compiled by default (the direct path),
# by --no-direct and by clang -O2, linked with its driver and run; the outputs and the undefined references compared.
set -uo pipefail
B=$1; dir=$2; t=$(mktemp -d)
for u in ctype constant-p; do
    "$B" --lanes 1 -std=gnu99 -O2 -c "$dir/$u.c" -o $t/direct.o; "$B" --no-direct --lanes 1 -std=gnu99 -O2 -c "$dir/$u.c" -o $t/full.o
    clang -std=gnu99 -O2 -c "$dir/$u.c" -o $t/clang.o; clang -O0 -c "$dir/$u-main.c" -o $t/m.o
    echo "== $u.c: $(readelf -p .comment $t/direct.o | grep -o 'buster direct\|buster-fast')"
    for v in direct full clang; do clang $t/m.o $t/$v.o -o $t/$v; echo "$v: $($t/$v)"; done
    diff <(nm $t/direct.o | grep ' U ') <(nm $t/full.o | grep ' U ') > /dev/null && echo "undefined references: the full pipeline's ($(nm $t/direct.o | grep ' U ' | awk '{print $2}' | tr '\n' ' '))"
done
rm -rf "$t"
