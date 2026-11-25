#!/bin/bash
# prints musl's 1,336 units (corpora.sh's set) one a line
C=${C:-/home/user/corpora}
musl=$C/libc/musl
export LC_ALL=C
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; echo "$f"; fi
done
