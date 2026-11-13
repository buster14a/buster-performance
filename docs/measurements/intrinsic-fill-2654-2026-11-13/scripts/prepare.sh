#!/bin/bash
# prepare.sh: the lists (musl's 1,336 units, the first source of each base name, and c-testsuite's 220) and the
# output directories. No lock: it runs no compiler.
set -u
cd "$(dirname "$0")"
. ./common.sh
rm -rf $t
mkdir -p $t/cache $t/lists $t/o
for d in base head scalar; do mkdir -p $t/m/$d $t/c/$d $t/s/$d $t/p/$d; done
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
printf '%s\n' "${files[@]}" > $t/lists/musl.txt
ls "$cts"/*.c > $t/lists/cts.txt
wc -l $t/lists/musl.txt $t/lists/cts.txt
