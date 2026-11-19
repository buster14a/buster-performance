#!/usr/bin/env bash
# Preprocesses one musl unit into OUT/<path below src, slashes as underscores>.i, line markers kept.
here=$(cd "$(dirname "$0")" && pwd)
source "$here/musl-opts.sh"
src=$1; out=$2
base=$(echo "$src" | sed 's|.*/src/||; s|/|_|g')
exec "${COMPILER:?}" -E "${opts[@]}" -o "$out/$base.i" "$src"
