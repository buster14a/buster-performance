#!/bin/bash
# run.sh COMPILER OUT.tsv: one.sh over the corpus in GNU's default mode, -std=c17 (musl: c99) and -std=c23.
P=$(realpath "$1"); out=$(realpath -m "$2"); here=$(cd "$(dirname "$0")" && pwd)
B=/home/user/buster; C=/home/user/corpora; L=$C/lua/src; M=$C/libc/musl
mflags=(-nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
{
  for mode in -std=gnu17 -std=c17 -std=c23; do
    (cd "$B" && git ls-files 'tests/*.c' 'tests/**/*.c') | sed "s|^|$B/|" | xargs -P 4 -n 1 "$here/one.sh" "$P" "$mode" tests
    ls "$B"/build/c-testsuite/tests/single-exec/*.c | xargs -P 4 -n 1 "$here/one.sh" "$P" "$mode" c-testsuite
    ls "$L"/*.c | xargs -P 4 -I{} "$here/one.sh" "$P" "$mode" lua {} -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX
  done
  for mode in -std=gnu99 -std=c99; do
    /home/user/work/musl-list.sh | xargs -P 4 -I{} "$here/one.sh" "$P" "$mode" musl {} "${mflags[@]}"
  done
} > "$out"
awk -F'\t' '{k=$1" "$2" a="$5" b="$7" "$8; n[k]++} END{for(k in n) print n[k], k}' "$out" | sort -k2
