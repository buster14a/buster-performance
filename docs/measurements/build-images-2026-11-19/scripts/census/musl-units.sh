#!/usr/bin/env bash
# Lists musl's units (first source of each base name, the one-core record's selection) and prints the options.
corpus=${CORPUS:?set CORPUS to the frozen corpus root (buster tools/ci/fetch-corpus.sh)}
musl="$corpus/libc/musl"
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; echo "$f"; fi
done
