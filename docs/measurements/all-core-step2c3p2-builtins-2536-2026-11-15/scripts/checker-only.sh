#!/bin/bash
set -u
exe=$1 out=$2
mkdir -p "$out/o"
one()
{
    local f=$1
    local b=checker.$(echo "$f" | tr '/' '_')
    (cd /home/user/buster && "$exe" --selection-census --lanes 1 -c "$f" -o "$out/o/$b.o" 2> "$out/o/$b.err" < /dev/null)
    printf '%s\t%s\n' "${f#/home/user/buster/}" "$(grep -P '^selection-census-builtins\t' "$out/o/$b.err" | cut -f2-)"
    rm -f "$out/o/$b".*
}
export -f one
export exe out
xargs -P "$(nproc)" -I{} bash -c 'one "$@"' _ {} < "$out/checker.files" > "$out/checker.txt"
