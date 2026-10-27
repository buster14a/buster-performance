#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/issue-612-codex"
mkdir -p evidence captures inputs commands
export EXCLUSIVE_OWNER=codex-612
export EXCLUSIVE_TITLE='Buster 612 overload declaration index'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/612
lock="$HOME/buster-fast-bench/exclusive.sh"
# Generic x86-64 helper binaries are built on the development host; compiler images are native 9700X builds.
for n in 2000 4000 8000; do ./generate overload "$n" > "inputs/overload-$n.c"; done
: > commands/overload.list
for n in 2000 4000 8000; do
 for variant in base head; do
  printf '%s-%s|cpu=2,runs=1,warmups=1,events=cycles:instructions,capture|%s/%s/build/compiler --lanes 1 -c %s/inputs/overload-%s.c -o %s/case.o\n' "$variant" "$n" "$PWD" "$variant" "$PWD" "$n" "$PWD" >> commands/overload.list
 done
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source_args="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
for variant in base head; do
 printf '%s-sqlite|cpu=2,runs=1,warmups=1,events=cycles:instructions,capture,var=SOURCE_DATE_EPOCH=1792454400|%s/%s/build/compiler --lanes 1 -c %s -o %s/sqlite.o\n' "$variant" "$PWD" "$variant" "$source_args" "$PWD" >> commands/overload.list
done
# One short benchmark invocation, with adjacent base/head pairs; --paired rotates cases and alternates each pair.
"$lock" ./procbench --paired --rounds 5 --out captures commands/overload.list > evidence/overload-matrix.tsv
sha256sum base/build/compiler head/build/compiler generate procbench inputs/* work/*.c > evidence/SHA256SUMS
printf 'measurement complete\n'
